import fs from "fs";
import { join } from "path";
import { RawSource } from "webpack-sources";
import {
  renderPageMarkup,
  renderFullPageDocument
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
    compiler.hooks.make.tapAsync(
      "StaticGeneratorPlugin",
      (compilation, callback) => {
        const pagesDir = fs.readdirSync(this.data.sourceDir);

        const allDataEntries = pagesDir.forEach(page => {
          const dataPath = join(this.data.sourceDir, page, "data.js");

          getComponentData(dataPath)
            .then(res => {
              compilation.assets[`${page}/initialData`] = new RawSource(
                JSON.stringify(res)
              );
            })
            .then(() => callback())
            .catch(err => callback(err));
        });
      }
    );

    compiler.hooks.emit.tap("StaticGeneratorPlugin", compilation => {
      const entrypoints = compilation.getStats().toJson().entrypoints;

      compilation.assets = Object.keys(entrypoints).reduce((acc, entry) => {
        const entryPath = join(this.data.sourceDir, entry, "Main.js");
        const bundles = entrypoints[entry].assets;
        const initialData = compilation.assets[`${entry}/initialData`].source();
        const html = renderPageMarkup(entryPath, initialData);

        acc[`${entry}/index.html`] = new RawSource(
          renderFullPageDocument({ html, bundles, initialData })
        );

        entrypoints[entry].assets.forEach(asset => {
          acc[`${entry}/${asset}`] = compilation.assets[asset];
        });
        return acc;
      }, {});
    });
  }
}

export default StaticGeneratorPlugin;
