"use strict";

describe("Config", () => {

  describe("#toJSON", () => {
    it("should be an object", () => {
      expect(Config).toBeInstanceOf(Object);
    });
  });

  describe("#get", () => {
    it("should have an server.api.servers", () => {
      expect(Config.server.api).toHaveProperty("servers");
    });

    it("should have an server.api.timeout", () => {
      expect(Config.server.api).toHaveProperty("timeout");
    });

    it("should have an environment", () => {
      expect(Config.environment).toHaveProperty("name");
      expect(Config.environment).toHaveProperty("server");
      expect(Config.environment).toHaveProperty("debug");
    });

    it("should evaluate falsey for string 'false'", () => {
      expect(
        Config.test_falsey_variable || Config.get("test_falsey_variable")
      ).toEqual(false);
    });
  });

  describe("#processConfigTree", () => {
    it("should retain configuration", () => {
      const myConfig = {
        animals: {
          cats: "the best",
          dogs: "the worst"
        }
      };
      expect(myConfig).toEqual(Config._processConfigTree(myConfig));
    });
  });

  describe("#toBrowserJSON", () => {
    it("should not contain redis information", () => {
      expect(Config.toBrowserJSON().server).not.toHaveProperty("redis");
    });
  });
});
