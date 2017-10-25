"use strict";

const CircuitBreaker = require("./circuit_breaker");

describe("CircuitBreaker", function() {
  describe("#run", function() {
    it("should work", function(done) {
      const mockFn = jest.fn();

      const myFunction = function(callback) {
        mockFn();
        callback();
      };

      const circuitBreaker = new CircuitBreaker("circuit", myFunction);
      circuitBreaker.run(function() {
        expect(mockFn).toHaveBeenCalledTimes(1);
        done();
      });
    });

    it("should fallback properly when the circuit is open", function(done) {
      const bestFelines = "cats";

      const myFailingFunction = function(testArg, callback) {
        spy();
        spy.calledOnce.should.be.false();
        throw new Error("should not reach this code");
      };

      const mockFn = jest.fn();

      const myWorkingFallback = function(testArg, callback) {
        expect(testArg).toEqual(bestFelines);
        mockFn();
        callback(testArg);
      };

      const circuitBreaker = new CircuitBreaker("circuit", myFailingFunction);
      circuitBreaker.fallback = new CircuitBreaker(
        "fallback",
        myWorkingFallback
      );

      circuitBreaker.open();
      circuitBreaker.run(bestFelines, function(testArg) {
        expect(testArg).toEqual(bestFelines);
        expect(mockFn).toHaveBeenCalledTimes(1);
        done();
      });
    });

    it("should fallback properly when the circuit is half-open", function(
      done
    ) {
      const bestFelines = "cats";

      const myFailingFunction = function(testArg, callback) {
        expect(testArg).toEqual(bestFelines);
        callback(testArg);
      };

      const mockFn = jest.fn();

      const myWorkingFallback = function(testArg, callback) {
        expect(testArg).toEqual(bestFelines);
        mockFn();
        callback(testArg);
      };

      const circuitBreaker = new CircuitBreaker("circuit", myFailingFunction);
      circuitBreaker.fallback = new CircuitBreaker(
        "fallback",
        myWorkingFallback
      );

      circuitBreaker.halfOpen();
      circuitBreaker.run(bestFelines, function(testArg) {
        expect(testArg).toEqual(bestFelines);
        expect(mockFn).toHaveBeenCalledTimes(1);
        done();
      });
    });

    it("should be asynchronous", function(done) {
      const waitTime = 50;

      const myFunction = function(callback) {
        setTimeout(function() {
          callback();
        }, waitTime);
      };

      const circuitBreaker = new CircuitBreaker("circuit", myFunction);

      let doneRunCounter = 0;

      const doneRun = function() {
        if (++doneRunCounter == 2) {
          const timeElapsed = new Date() - start;
          expect(timeElapsed).toBeLessThan(waitTime * 2);
          done();
        }
      };

      const start = new Date();
      circuitBreaker.run(doneRun);
      circuitBreaker.run(doneRun);
    });
  });
});
