// const entrypoints = compilation.getStats().toJson().entrypoints;

// const promisedVal = new Promise((resolve, reject) => {
//   setTimeout(resolve({ github: { login: "pruett" } }), 7000);
// });

// const updatedAssets = Object.keys(entrypoints).reduce((acc, entry) => {
//   const componentPath = join(this.data.sourceDir, entry, "Main.js");
//   const dataPath = join(this.data.sourceDir, entry, "data.js");

//   const html = promisedVal.then(data =>
//     renderStringifiedMarkup(componentPath, data)
//   );
//   const bundles = entrypoints[entry].assets;

//   acc[`${entry}/index.html`] = new RawSource(
//     renderFullPageMarkup({ html, bundles })
//   );
//   entrypoints[entry].assets.forEach(asset => {
//     acc[`${entry}/${asset}`] = compilation.assets[asset];
//   });

//   return acc;
// }, {});
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
import { join } from "path";
import { RawSource } from "webpack-sources";
import {
  renderFullPageMarkup,
  renderStringifiedMarkup
} from "../utils/staticRenderUtils";
import { fetchData } from "../utils/dataFetchingUtils";

async function getComponentData(path) {
  const dataImport = await import(path);
  return await fetchData(dataImport.default);
}

class StaticGeneratorPlugin {
  constructor(config = {}) {
    const defaults = {
      sourceDir: join(__dirname, "..", "..", "pages")
    };
    this.data = Object.assign(defaults, config);
  }

  apply(compiler) {
    compiler.hooks.make.tap("StaticGeneratorPlugin", compilation => {
      const dataPath = join(this.data.sourceDir, "hello-world", "data.js");

      getComponentData(dataPath).then(res => {
        compilation.assets["hello-world-data"] = new RawSource(res);
      });
    });

    compiler.hooks.emit.tapAsync("StaticGeneratorPlugin", compilation => {
      debugger;
    });
  }
}

export default StaticGeneratorPlugin;
