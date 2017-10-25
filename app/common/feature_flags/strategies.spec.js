'use strict';

describe('featureFlags', function() {

  var ff = require('./');
  var strategies = require('./strategies');

  describe('StaticValueStrategy', function() {
    it('should parse a well-defined strategy', function() {
      var feature = ff.Feature.fromObject({
        'name': 'test-feature',
        'strategy': {
          'type': 'static',
          'value': true
        },
        'meta': {}
      });

      expect(feature.name).toEqual('test-feature');
      expect(feature.strategy.value).toEqual(true);
    });

    it('should throw an error if the strategy is not well-defined', function() {
      expect(function() {
        ff.Feature.fromObject({
          'name': 'favorite-number',
          'strategy': {
            'type': 'static',
            'value': 42
          },
          'meta': {}
        });
      }).toThrow();
    });

    it('should evaluate correctly', function() {
      var strategy = new strategies.StaticValueStrategy(true);
      var mockFn = jest.fn();      
      strategy.evaluate(mockFn);      
      expect(mockFn).toHaveBeenLastCalledWith(null, strategy.value);
    });
  });

  describe('CutoverStrategy', function() {
    it('should parse a well-defined strategy', function() {
      var feature = ff.Feature.fromObject({
        'name': 'test-feature',
        'strategy': {
          'type': 'cutover',
          'value_before': false,
          'value_at_and_after': true,
          'cutover': '1986-05-06T00:00:00Z'
        },
        'meta': {}
      });

      expect(feature.name).toEqual('test-feature');
      expect(feature.strategy.valueBefore).toEqual(false);
      expect(feature.strategy.valueAtAndAfter).toEqual(true);
      expect(feature.strategy.cutover).toEqual(new Date('1986-05-06T00:00:00Z'));
    });

    it('should throw an error if the strategy is not well-defined', function() {
      expect(function() {
        ff.Feature.fromObject({
          'name': 'test-feature',
          'strategy': {
            'type': 'cutover',
            'value_at_and_after': true,
            'cutover': '1986-05-06T00:00:00Z'
          },
          'meta': {}
        });
      }).toThrow();
    });

    it('should evaluate correctly', function() {
      const strategy = new strategies.CutoverStrategy({
        value_before: false,
        value_at_and_after: true,
        cutover: new Date('1986-05-06T00:00:00Z')
      });

      const rightBefore = new Date('1986-05-05T00:00:00Z');
      const rightAt = new Date('1986-05-06T00:00:00Z');
      const rightAfter = new Date('1986-05-06T00:01:00Z');

      const mock = jest.fn();

      strategy.evaluate(mock);
      expect(mock).toHaveBeenLastCalledWith(null, true)

      strategy.evaluate(mock, rightBefore);
      expect(mock).toHaveBeenLastCalledWith(null, false)

      strategy.evaluate(mock, rightAt);
      expect(mock).toHaveBeenLastCalledWith(null, true)

      strategy.evaluate(mock, rightAfter);
      expect(mock).toHaveBeenLastCalledWith(null, true)

      strategy.evaluate(mock, 'not a date');
      expect(mock).toHaveBeenLastCalledWith("Provided time is not of type Date", false);      
    });
  });
});
