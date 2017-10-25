"use strict";

describe("featureFlags", () => {
  const ff = require("./index");

  describe("Feature", () => {
    test("should throw an error without a strategy", () => {
      expect(() => {
        ff.Feature.fromObject({
          name: "test-feature",
          meta: {}
        });
      }).toThrow();
    });

    test("should throw an error with an non-existant strategy", () => {
      expect(() => {
        ff.Feature.fromObject({
          name: "test-feature",
          strategy: {
            type: "cowabunga"
          },
          meta: {}
        });
      }).toThrow();
    });
  });
});
