const { transformDeepArray } = require("./helpers");
const Backbone = require("hedeia/common/backbone/backbone");

describe("Collection helpers", () => {
  describe("TransformDeepArray", () => {
    it("Should return an empty object if no arguments are passed", () => {
      expect(transformDeepArray()).toEqual({});
    });
    it("Should remove null values", () => {
      const myArray = [null];
      expect(transformDeepArray(myArray)).toEqual({});
    });
    it("Should return truthy values keyed by id", () => {
      const mockAPIResponse = {
        products: { 1: null, 2: null, 3: { product_id: 3, name: "andy" } }
      };
      const deepModel = new Backbone.BaseModel(mockAPIResponse);
      const attrs = deepModel.toJSON().products;
      expect(transformDeepArray(attrs)).toEqual({
        3: { product_id: 3, name: "andy" }
      });
    });
  });
});
