import { join } from "path";
import { readdirSync } from "fs";
import DynamicEntryPlugin from "webpack/lib/DynamicEntryPlugin";
import ReactDOMServer from "react-dom/server";
import template from "../src/template";

class StaticCompilerPlugin {
  constructor(config) {
    const defaults = { sourceDir: "pages" };
    this.data = Object.assign(defaults, config);
  }

  get filePath() {
    return join(__dirname, "..", this.data.sourceDir);
  }

  get entries() {
    return readdirSync(this.filePath);
  }

  static addEntry(compilation, context, chunkName, filename) {
    return new Promise((resolve, reject) => {
      const dep = DynamicEntryPlugin.createDependency(filename, chunkName);
      compilation.addEntry(context, dep, chunkName, err => {
        if (err) return reject(err);
        resolve();
      });
    });
  }

  apply(compiler) {
    compiler.hooks.make.tapAsync("StaticCompilerPlugin", (compilation, cb) => {
      // Loop over folders inside <sourceDir>
      // and add their associated index.js files
      // as entrypoints
      const allEntries = this.entries.map(chunkName => {
        return StaticCompilerPlugin.addEntry(
          compilation,
          compiler.context,
          chunkName,
          `${this.filePath}/${chunkName}/index.js`
        );
      });

      Promise.all(allEntries)
        .then(() => cb())
        .catch(cb);
    });

    compiler.hooks.emit.tap("StaticCompilerPlugin", compilation => {
      const allChunks = compilation.getStats().toJson().chunks;
      const templateAsset = ReactDOMServer.renderToString(template);
      debugger;
    });
  }
}

export default StaticCompilerPlugin;
