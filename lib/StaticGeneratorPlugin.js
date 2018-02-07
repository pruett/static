import { join } from "path";
import { RawSource } from "webpack-sources";
import {
  renderFullPageMarkup,
  renderStringifiedMarkup
} from "../src/utils/staticRenderUtils";

class StaticGeneratorPlugin {
  constructor(config = {}) {
    const defaults = { sourceDir: "pages" };
    this.data = Object.assign(defaults, config);
  }

  apply(compiler) {
    compiler.hooks.emit.tap("StaticGeneratorPlugin", compilation => {
      const allChunks = compilation.getStats().toJson().chunks;
      const entrypoints = compilation.getStats().toJson().entrypoints;

      /*
       *
       * CAUTION: MUTATION AHEAD

       * Below we are mutating the `compilation.assets` object
       * that delivers the final assets to our output directory

       * We are adding an `index.html` file to each entrypoint and moving
       * entrypoint-specific chunks into their respective directories

       * e.g.:
       *   Original (flat asset graph) --
       *       { one.js, two.js, three.js }

       *   Mutated (structured asset graph) --
       *       { one: { index.html, one.js },
       *         two: { index.html, two.js },
       *         three: { index.html, three.js }
       *       }
       *
      */

      debugger;
      // compilation.assets = Object.keys(entrypoints).reduce((acc, entry) => {
      //   acc[`${entry}/index.html`] = new RawSource(
      //     render(join(__dirname, "..", this.data.sourceDir, entry, "Main.js"))
      //   );
      //   entrypoints[entry].assets.forEach(asset => {
      //     acc[`${entry}/${asset}`] = compilation.assets[asset];
      //   });

      //   return acc;
      // }, {});
    });
  }
}

export default StaticGeneratorPlugin;
