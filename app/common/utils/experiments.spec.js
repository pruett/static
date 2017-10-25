const _ = require("lodash");
const Experiments = require("./experiments");

const knownSeeds = [
  ["b7a884bd", 2033360174],
  ["092a1522", 2349671999],
  ["7b385747", 2830066644],
  ["f207f5af", 3556790500],
  ["485d806a", 410777570],
  ["4889f888", 2277380521],
  ["c4b909f4", 1662359896],
  ["0c9cb6ff", 115500698],
  ["ec335b19", 3916635183],
  ["645e0307", 1714990624],
  ["34862f4d", 3519081670],
  ["018129fd", 3869064359],
  ["0bbb713f", 3913604642],
  ["052e32df", 4157884618],
  ["e39798fc", 2092840976],
  ["fbe292f7", 3353224958]
];

const userSeed = "20eb11da";
const experimentSeed1 = "f26c08ec";
const experimentSeed2 = "0874aad1";
const experimentSeed3 = "d56241ef";
const experimentSeed4 = "123a3cd5";

const experiments = {
  [experimentSeed1]: {
    name: "checkoutEnhancements",
    attributes: { experiment_groups: ["alpha"] },
    variants: [
      { name: "foo", weight: 50 },
      { name: "bar", weight: 50 },
      { name: "baz", weight: 50 }
    ],
    traffic: 100
  },

  [experimentSeed2]: {
    name: "smartBanner",
    variants: [{ name: "foo", weight: 50 }, { name: "bar", weight: 50 }],
    attributes: { experiment_groups: ["alpha"] },
    traffic: 100
  },

  [experimentSeed3]: {
    name: "dumbBanner",
    variants: [{ name: "foo", weight: 50 }, { name: "bar", weight: 50 }],
    attributes: { experiment_groups: ["alpha"] },
    traffic: 100
  },

  [experimentSeed4]: {
    name: "offBanner",
    variants: [{ name: "foo", weight: 50 }, { name: "bar", weight: 50 }],
    traffic: 0
  }
};

const randomSeed = () => Experiments.newSeed();

const createExperiment = (variantCount = 2, groups = ["beta"]) => {
  return {
    [randomSeed()]: {
      name: _.uniqueId("experiment_"),
      variants: _.map(Array(variantCount), () => {
        return {
          name: _.uniqueId("variant_"),
          weight: 50
        };
      }),
      traffic: 100,
      attributes: {
        experiment_groups: groups
      }
    }
  };
};

const computeKnown = (options = {}, unpack = true, seed) => {
  if (!seed) seed = userSeed;
  const state = Experiments.computeState(seed, experiments, options);
  if (unpack) {
    return state.active[experimentSeed1];
  } else {
    return state;
  }
};

describe("Experiments", () => {
  describe("#newSeed", () => {
    it("should generate a new seed", () => {
      expect(_.isString(Experiments.newSeed())).toBe(true);
    });
  });

  describe("#randomInt", () => {
    return _.each(_.range(0, _.size(knownSeeds), 2), function(index) {
      const seed = knownSeeds[index][0];
      const expected = knownSeeds[index][1];
      const rand = Experiments.getGenerator(seed);
      const iterations = Math.pow(2, index);

      it(
        "should generate " +
          _.padStart(expected, 10) +
          " after " +
          _.padStart(iterations, 5) +
          " iterations with seed '" +
          seed +
          "'",
        () => {
          _.times(iterations, () => rand.randomInt());

          return expect(rand.randomInt()).toEqual(expected);
        }
      );
    });
  });

  describe("#isValidSeed", () => {
    it("should validate seeds", () => {
      expect(Experiments.isValidSeed(Experiments.newSeed())).toEqual(true);
      expect(Experiments.isValidSeed("ABCDEF12")).toEqual(true);
      expect(Experiments.isValidSeed("1 2 3 4 ")).toEqual(false);
      expect(Experiments.isValidSeed("123456789")).toEqual(false);
      expect(Experiments.isValidSeed("")).toEqual(false);
      expect(Experiments.isValidSeed(null)).toEqual(false);
      expect(Experiments.isValidSeed("1234567g")).toEqual(false);
    });
  });

  describe("#computeState", () => {
    it("should work with no experiments", () => {
      expect(Experiments.computeState(userSeed, {})).toEqual({
        active: {},
        nameMapId: {},
        seed: userSeed,
        groups: {}
      });
    });

    it("should work with integer seed", () => {
      const intUserSeed = parseInt(userSeed, 16);
      expect(computeKnown({}, true, intUserSeed).state.participant).toEqual(true);
    });

    describe("with a known sample", () => {
      it("should be a participant", () => {
        expect(computeKnown().state.participant).toEqual(true);
      });
      it("should compute the variant to be 'baz'", () => {
        expect(computeKnown().state.variant).toEqual("baz");
      });
      it("should be in traffic slot 72", () => {
        expect(computeKnown().state.traffic_slot).toEqual(72);
      });
      it("should be in variant slot 141", () => {
        expect(computeKnown().state.variant_slot).toEqual(141);
      });
      it("should list all variants in an Array", () => {
        expect(computeKnown().all_variants).toEqual(["foo", "bar", "baz"]);
      });
      it("should map groups", () => {
        expect(computeKnown({}, false).groups).toEqual({
          alpha: {
            experiment: experimentSeed1,
            group_slot: 2,
            all: [experimentSeed1, experimentSeed2, experimentSeed3].sort()
          }
        });
      });
    });
    describe("with disableAll: true", () => {
      it("should not have any active experiments", () => {
        expect(
          _.isEmpty(
            computeKnown(
              {
                disableAll: true
              },
              false
            ).active
          )
        ).toEqual(true);
      });
    });

    describe("with force option", () => {
      it('should be in variant "foo" when forced', () => {
        const forced = computeKnown({
          force: {
            experiment: "checkoutEnhancements",
            variant: "foo"
          }
        });
        expect(forced.state.variant).toEqual("foo");
        expect(forced.state.forced).toEqual(true);
      });

      it('should be in variant "foo" when forced despite bucketState', () => {
        const bucket = computeKnown({
          bucketState: { [experimentSeed1]: "bar" },
          force: {
            experiment: "checkoutEnhancements",
            variant: "foo"
          }
        });
        expect(bucket.state.participant).toEqual(true);
        expect(bucket.state.variant).toEqual("foo");
        expect(bucket.state.bucketed).toEqual(true);
      });
    });

    describe("with mutually exclusive experiments", () => {
      it("should only allow participation in one experiment per group", () => {
        const mutex = Experiments.computeState(
          randomSeed(),
          _.reduce(Array(10), acc => _.assign(acc, createExperiment()), {})
        );
        const active = mutex.active;
        const participating = _.filter(active, {
          state: {
            participant: true
          }
        });
        expect(participating.length).toEqual(1);
        expect(mutex.groups.beta.all.length).toEqual(10);
        expect(active[mutex.groups.beta.experiment].state.participant).toEqual(true);
      });
    });

    describe("with bucket state", () => {
      it('should be in variant "bar" when specified by the bucketState', () => {
        const bucket = computeKnown({
          bucketState: { [experimentSeed1]: "bar" }
        });
        expect(bucket.state.participant).toEqual(true);
        expect(bucket.state.variant).toEqual("bar");
        expect(bucket.state.bucketed).toEqual(true);
      });

      it("should handle mutual exclusivity with bucket state", () => {
        const bucket = computeKnown(
          {
            bucketState: { [experimentSeed2]: "bar" }
          },
          false
        );
        const results = [];
        for (let experimentSeed in bucket.active) {
          const experiment = bucket.active[experimentSeed];
          if (experimentSeed === experimentSeed2) {
            expect(experiment.state.participant).toEqual(true);
            expect(experiment.state.bucketed).toEqual(true);
          } else {
            expect(experiment.state.participant).toEqual(false);
          }
        }
      });
    });
  });

  describe("#__getIntendedType", () => {
    it("show return integers", () => {
      expect(Experiments.__getIntendedType(1)).toEqual(1);
    });
    it("show return string integers as integers", () => {
      expect(Experiments.__getIntendedType("1")).toEqual(1);
    });
    it("show return string booleans as booleans", () => {
      expect(Experiments.__getIntendedType("true")).toEqual(true);
      expect(Experiments.__getIntendedType("false")).toEqual(false);
    });
    it("show return value if not matching above", () => {
      expect(Experiments.__getIntendedType("x")).toEqual("x");
    });
  });

  describe("#de/serializeState", () => {
    const states = _.map(Array(5), () => {
      return {
        [randomSeed()]: _.uniqueId("variant"),
        [randomSeed()]: _.uniqueId("variant")
      };
    });
    _.each(states, function(state) {
      const serialized = Experiments.serializeState(state);

      it(JSON.stringify(state) + " <=> " + serialized, () => {
        const deserialized = Experiments.deserializeState(serialized);
        expect(deserialized).toEqual(state);
      });
    });

    it("should not deserialize invalid values", () => {
      const serialized = new Buffer("not-valid=bar&valid=yes").toString("base64");
      expect(Experiments.deserializeState(serialized)).toEqual({
        valid: "yes"
      });
    });

    it("should accept undefined or null values", () => {
      expect(Experiments.serializeState(null)).toEqual("");
      expect(Experiments.serializeState(void 0)).toEqual("");
      expect(
        Experiments.serializeState({
          "strange=pair": "foo"
        })
      ).toEqual("");
      expect(Experiments.deserializeState(null)).toEqual({});
      expect(Experiments.deserializeState(void 0)).toEqual({});
    });
  });

  describe("#sweepState", () => {
    it("should sweep experiments that do not exist", () => {
      const state = { [experimentSeed1]: "foo", ["00000000"]: "bar" };
      const swept = Experiments.sweepState(state, experiments);
      expect(swept.state).toEqual({ [experimentSeed1]: "foo" });
      expect(swept.changed).toEqual(true);
    });

    it("should return null if nothing is swept", () => {
      const state = { [experimentSeed1]: "foo" };
      const swept = Experiments.sweepState(state, experiments);
      expect(swept.changed).toEqual(false);
    });

    it("should return true if no experiments", () => {
      const state = { [experimentSeed1]: "foo" };
      const emptyExperiments = null;
      const swept = Experiments.sweepState(state, emptyExperiments);
      expect(swept.changed).toEqual(true);
    });
  });

  describe("#__isUserParticipant", () => {
    const experimentTrue = { attributes: { session_data: ["cart.quantity=2"] } };
    const experimentFalse = { attributes: { session_data: ["cart.quantity<2"] } };
    const userData = { cart: { quantity: 2 } };

    it("should support conditional-based participation through `session_data`", () => {
      expect(Experiments.__isUserParticipant(userData, experimentTrue)).toEqual(true);
      expect(Experiments.__isUserParticipant(userData, experimentFalse)).toEqual(false);
    });    
  });

  describe("#__getParticipantFromUserData", () => {
    const userData = { cart: { quantity: 2 } };
    it("should return false if invalid/non-supported operator", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity%2", userData)).toEqual(false);
    });
    it("should return false if no userData", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity>2", null)).toEqual(false);
    });
    it("should support less than (<)", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity<2", userData)).toEqual(false);
    });
    it("should support equal (=)", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity=2", userData)).toEqual(true);
    });
    it("should support greater than (>)", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity>2", userData)).toEqual(false);
    });
    it("should support greater than (!=)", () => {
      expect(Experiments.__getParticipantFromUserData("cart.quantity!=2", userData)).toEqual(false);
    });
  });
});
