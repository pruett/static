describe("className helpers", () => {
  const { ƒ, µ, trim } = require("./classNames");

  describe("µ : Multi-line", () => {
    it("should remove extra spaces", () => {
      const klass = µ`
      foo
      bar
    `;
      expect(klass).toMatchSnapshot();
    });

    it("should resolve interpolations", () => {
      const klass = foo => µ`
      foo
      ${foo}
    `;
      expect(klass("bar")).toMatchSnapshot();
    });
  });

  describe("trim", () => {
    it("should remove extra spaces", () => {
      const klass = trim("foo");
      expect(klass).toMatchSnapshot();
    });
  });

  describe("ƒ : Ternary function", () => {
    describe("`bool` is truthy", () => {
      it("should return `left` argument", () => {
        expect(ƒ(true)("foo", "bar")).toEqual("foo");
      });

      it("should return `left` argument", () => {
        expect(ƒ(true)("foo")).toEqual("foo");
      });

      it("should return empty string if no arguments", () => {
        expect(ƒ(true)()).toEqual("");
      });
    });

    describe("`bool` is falsy", () => {
      it("should return `right` argument", () => {
        expect(ƒ(false)("foo", "bar")).toEqual("bar");
      });

      it("should return empty string if no `right` argument", () => {
        expect(ƒ(false)("foo")).toEqual("");
      });

      it("should return empty string if no arguments", () => {
        expect(ƒ(false)()).toEqual("");
      });
    });

    describe("no `left`/`right` arguments", () => {
      it("should return callback if no arguments", () => {
        expect(typeof ƒ(true)).toBe("function");
      });
    });

    describe("two separate functions", () => {
      const foo = ƒ(true);
      it("should return first argument", () => {
        expect(foo("baz", "bar")).toBe("baz");
      });
    });
  });
});
