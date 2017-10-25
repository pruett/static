const _ = require("lodash");
const MersenneTwister = require("mersennetwister");

const HEX_DIGITS = "0123456789abcdef";
const VALID_DESERIALIZED_VALUE = /^\w+$/i;
const EXPERIMENT_DELIMITER = "|";

MersenneTwister.prototype.randomInt = function() {
  // Returns a 32-bit integer.
  return Math.floor(4294967296 * this.rndHiRes());
};

module.exports = {
  newSeed() {
    return _.map(new Array(8), () => _.sample(HEX_DIGITS)).join("");
  },

  isValidSeed(seed) {
    if (!_.isString(seed)) {
      return false;
    }
    return Boolean(seed.match(/^[\da-f]{8}$/i));
  },

  getGenerator(seed) {
    if (_.isString(seed)) {
      seed = parseInt(seed, 16);
    }
    return new MersenneTwister(seed);
  },

  __getIntendedType(value) {
    if (!_.isNaN(parseInt(value))) {
      return parseInt(value);
    } else if (value === "true") {
      return true;
    } else if (value === "false") {
      return false;
    } else {
      // String.
      return value;
    }
  },

  deserializeState(encodedValue) {
    // Transforms a base64 encoded value to an object only when the key/values
    // validate against the VALID_DESERIALIZED_VALUE regular expression.
    //
    // 1. NTUxNmJkMmU9Zm9vJjA5MmExNTIyPWJhcg==    # Base64 encoded.
    // 2. 5516bd2e=foo&092a1522=bar               # Query string.
    // 3. {"5516bd2e": "foo", "092a1522": "bar"}  # Object.
    let value;
    if (_.isEmpty(encodedValue)) {
      return {};
    }

    try {
      value = new Buffer(`${encodedValue}`, "base64").toString();
    } catch (e) {
      return {};
    }

    const pairs = value.split("&");

    return _.reduce(
      pairs,
      function(acc, el) {
        const [experimentSeed, variantName] = el.split("=");
        if (
          VALID_DESERIALIZED_VALUE.test(experimentSeed) &&
          VALID_DESERIALIZED_VALUE.test(variantName)
        ) {
          acc[experimentSeed] = variantName;
        }
        return acc;
      },
      {}
    );
  },

  serializeState(state) {
    // Transforms an object into a base64 encoded value when the key/values
    // validate against the VALID_DESERIALIZED_VALUE regular expression.
    //
    // We encode to base64 because it's portable as a cookie value.
    //
    // 1. {"5516bd2e": "foo", "092a1522": "bar"}  # Object.
    // 2. 5516bd2e=foo&092a1522=bar               # Query string.
    // 3. NTUxNmJkMmU9Zm9vJjA5MmExNTIyPWJhcg==    # Base64 encoded.
    const queryString = _.map(state, function(variantName, experimentSeed) {
      if (
        VALID_DESERIALIZED_VALUE.test(experimentSeed) &&
        VALID_DESERIALIZED_VALUE.test(variantName)
      ) {
        return `${experimentSeed}=${variantName}`;
      }
    }).join("&");

    return new Buffer(queryString).toString("base64");
  },

  sweepState(state, experiments) {
    // Sweep any experiments that no longer exist.
    if (experiments == null) {
      experiments = {};
    }
    const sweptState = {};
    let anySwept = false;
    for (const experimentSeed in state) {
      const variantName = state[experimentSeed];
      if (experiments[experimentSeed]) {
        sweptState[experimentSeed] = variantName;
      } else {
        anySwept = true;
      }
    }
    return { state: sweptState, changed: anySwept };
  },

  __getExperimentGroups(experiment) {
    return _.filter(
      // Filter out empty group name strings.
      _.get(experiment, "attributes.experiment_groups", []),
      group => _.some(_.trim(group))
    );
  },

  __getVariant(experiment, totalVariantWeight, forced, rand) {
    let variant;
    const variant_slot = rand.randomInt() % totalVariantWeight;

    if (forced) {
      variant = forced;
    } else {
      let variant_slice = 0;
      for (const candidate of experiment["variants"]) {
        variant_slice += candidate["weight"];
        if (variant_slot < variant_slice) {
          variant = candidate["name"];
          break;
        }
      }
    }

    return {
      participant: true,
      variant_slot,
      variant
    };
  },

  computeState(seed, experiments, options = {}) {
    /*
    Given a dict of experiments and a user's seed, deterministically compute
    whether they are participants and if so, what variants they should be
    bucketed in.

    seed -- a valid seed.
    experiments -- a dict of experiments, keyed by a valid seed. Example:
        {
            "5516bd2e": {
                "name": "myExperimentName",
                "groups": [
                  "segmentation",
                  "homeHero"
                ]
                "variants": [
                    {
                        "name": "foo",
                        "weight": 50,
                    },
                    {
                        "name": "bar",
                        "weight": 50,
                    },
                ],
                "traffic": 50,
            }
        }
    */
    _.defaults(options, {
      disableAll: false,
      force: {},
      session: null,
      bucketState: ""
    });

    const { bucketState, force } = options;

    const forcedExperiments = _.zipObject(
      (force.experiment || "").split(EXPERIMENT_DELIMITER),
      (force.variant || "").split(EXPERIMENT_DELIMITER)
    );

    const result = {
      active: {},
      nameMapId: {},
      seed,
      groups: {}
    };

    if (_.isEmpty(experiments) || options.disableAll) {
      return result;
    }

    if (_.isString(seed)) {
      seed = parseInt(seed, 16);
    }

    // When force options or bucket state dictate an experiment variant, the
    // experiment seed is stored here so that the mutual exclusion check is
    // forced to keep the existing experiment assignment.
    const bucketed = {};
    const grouped = {};

    for (const experimentSeed in experiments) {
      const experiment = experiments[experimentSeed];
      let forceVariant = null;
      experiment.groups = this.__getExperimentGroups(experiment);

      // Note that traffic should be a value from 0 to 100, indicating
      // the percentage of traffic this experiment should receive.
      let traffic = _.get(experiment, "traffic", 100);
      traffic = Math.min(100, Math.max(0, traffic));
      if (traffic === 0 && !forcedExperiments[experiment.name]) {
        continue;
      }

      result.nameMapId[experiment.name] = experimentSeed;
      result.active[experimentSeed] = {
        name: experiment.name,
        all_variants: []
      };

      // Xor the user seed and experiment seed to generate a unique
      // seed for each experiment.
      const rand = this.getGenerator(parseInt(experimentSeed, 16) ^ seed);

      // Traffic allocation must stay consistent so an experiment can be scaled
      // up and maintain the same set users as participants.
      const traffic_slot = rand.randomInt() % 100;
      let participant =
        traffic_slot < traffic &&
        this.__isUserParticipant(
          _.assign({}, options.session, options.personalization),
          experiment
        );

      const state = {
        bucketed: false,
        forced: false,
        participant,
        traffic_slot,
        variant: null
      };

      let totalVariantWeight = 0;

      for (const variant of experiment["variants"]) {
        if (forcedExperiments[experiment.name] === variant.name) {
          state.forced = true;
          participant = true;
          forceVariant = variant.name;
        }
        if (bucketState[experimentSeed] === variant.name) {
          state.bucketed = true;
          participant = true;
          if (!state.forced) {
            forceVariant = variant.name;
          }
        }

        totalVariantWeight += variant["weight"];
        result.active[experimentSeed]["all_variants"].push(variant.name);
      }

      _.assign(result.active[experimentSeed], {
        attributes: _.get(experiment, "attributes", {}),
        traffic
      });

      if (participant) {
        _.assign(state, this.__getVariant(experiment, totalVariantWeight, forceVariant, rand));
      }

      // Build up groups for mutually exclusive experiments
      result.active[experimentSeed]["state"] = state;

      _.each(experiment.groups, function(group) {
        if (forceVariant) {
          bucketed[group] = experimentSeed;
        }
        if (!grouped[group]) {
          grouped[group] = {};
        }
        if (participant) {
          return (grouped[group][experimentSeed] = result.active[experimentSeed]);
        }
      });
    }

    for (const groupName in grouped) {
      // User is allowed to participate in one experiment per group.
      const groupedExperiments = grouped[groupName];
      const keys = _.keys(groupedExperiments).sort();

      const groupSeed = _.reduce(
        keys,
        (acc, experimentSeed) => parseInt(experimentSeed, 16) ^ acc,
        seed
      );

      const rand = this.getGenerator(groupSeed);
      const groupSlot = rand.randomInt() % _.size(keys);

      grouped[groupName] = {
        // Sticky/forced state takes precedence over slot.
        experiment: bucketed[groupName] || keys[groupSlot],
        group_slot: groupSlot,
        all: keys
      };
    }

    for (const groupName in grouped) {
      const group = grouped[groupName];
      for (const experimentSeed of group.all) {
        if (experimentSeed !== group.experiment && result.active[experimentSeed]) {
          result.active[experimentSeed].state.participant = false;
        }
      }
    }

    result.groups = grouped;
    return result;
  },

  __isUserParticipant(userData, experiment) {
    // User data contains session endpoint data and personalization endpoint data
    // If there are session or personalization data conditions set, confirm that each is met by the
    // prefetched data.

    const conditions = _.get(experiment, "attributes.session_data", []);
    if (!(conditions.length > 0)) {
      return true;
    }

    // Check each condition against session data.
    return conditions.reduce((acc, condition) => {
      return acc && this.__getParticipantFromUserData(condition, userData);
    }, true);
  },

  __getParticipantFromUserData(condition, userData) {
    // Parse a {key}{operator}{value} string (e.g. `cart.quantity>1`), passed
    // as a condition for participation in the experiment, as a boolean.

    let operator = condition.match(/<|=|>|!=/);
    if (!operator || !userData) {
      return false;
    }

    operator = operator[0];
    const arr = condition.split(operator);
    const field = arr[0];
    let testValue = arr[1];
    let userValue = _.get(userData, field);

    userValue = this.__getIntendedType(userValue);
    testValue = this.__getIntendedType(testValue);

    return (() => {
      switch (operator) {
        case "<":
          return userValue < testValue;
        case "=":
          return userValue === testValue;
        case ">":
          return userValue > testValue;
        case "!=":
          return userValue !== testValue;
      }
    })();
  }
};
