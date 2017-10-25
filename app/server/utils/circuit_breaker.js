'use strict';

/**
 * A wrapper of Levee's implementation of circuit breakers.
 *
 * A circuit breaker is a resiliency pattern for detecting errors and timeouts at integration
 * points. By detecting errors and timeouts and failing fast when error rates are high, the hope
 * is particular failure modes are contained and don't take down the rest of the system.
 *
 * Levee code:
 *   https://github.com/krakenjs/levee
 * Martin Fowler's description of a circuit breaker:
 *   https://martinfowler.com/bliki/CircuitBreaker.html
 */

var Levee = require('levee');
var Logger = require('hedeia/server/logger');
var Metrics = require('hedeia/server/utils/metrics');

var AVAILABLE_EVENTS = [
    'failure',   // error is returned
    'timeout',   // more than max seconds is elapsed
    'reject',    // circuit is open, fail fast
    'duration',  // event that gives the duration of the function call in question
    'execute',   // whenever "run" is executed
    'success',   // any time the function successfully runs
    'open',      // circuit state is set to open
    'half_open', // circuit state is set to half-open
    'close'      // circuit state is set to closed
];

var RECORDED_EVENTS = ['open', 'close'];

var STATE_MAP = {
    'closed': 'CLOSE',
    'open': 'OPEN'
};

var logger = Logger.get('CircuitBreaker', {file: __filename});

/**
 * A wrapper of Levee's implementation of circuit breakers.
 *
 * @param name The name of this circuit for record keeping purposes.
 * @param impl The function to wrap in the circuit breaker.
 * @param options Configuration dictionary for the Levee circuit breaker, see their documentation.
 * @param fallbackFunction Function to run in case of an open circuit. Can be empty.
 * @constructor
 */
var CircuitBreaker = function(name, impl, options, fallbackFunction) {
    if (typeof impl === 'function') {
        impl = { execute: impl };
    }

    this._name = name.replace(/ /g, '_');
    this._registerEventListeners();
    this._overrideStateFromConfig();

    Levee.Breaker.call(this, impl, options);

    if (fallbackFunction) {
      this.fallback = Levee.createBreaker(fallbackFunction);
    }
};

CircuitBreaker.prototype = Object.create(Levee.Breaker.prototype);
CircuitBreaker.prototype.constructor = Levee.Breaker;

CircuitBreaker.prototype.run = function run() {
    this._overrideStateFromConfig();
    Levee.Breaker.prototype.run.apply(this, arguments);
};

CircuitBreaker.prototype.recordEvent = function recordEvent(eventType) {
    logger.info('Circuit breaker event!', this._name, eventType);

    Metrics.increment("circuit_breaker." + this._name + "." + eventType);
};

CircuitBreaker.prototype._stateIsOverridenByConfig = function _stateIsOverridenByConfig(state) {
    var configKey = "server.circuit_breaker." + this._name + "_" + state;

    if (Config.has(configKey)) {
        return Config.get(configKey);
    } else {
        return false;
    }
};

CircuitBreaker.prototype._setStateFromConfig = function _setStateFromConfig(state) {
    if (STATE_MAP[state] !== this._state && this._stateIsOverridenByConfig(state)) {
        logger.info('Circuit breaker ' + this._name + ' forced into ' + state + ' state by config.');
        this._setState(STATE_MAP[state]);
    }
};

CircuitBreaker.prototype._overrideStateFromConfig = function _overrideStateFromConfig() {
    this._setStateFromConfig('open');
    this._setStateFromConfig('closed');
};

CircuitBreaker.prototype._registerEventListeners = function _registerEventListeners() {
  RECORDED_EVENTS.forEach(function (eventType) {
      this.on(eventType, this.recordEvent.bind(this, eventType));
  }, this);
};

module.exports = CircuitBreaker;
