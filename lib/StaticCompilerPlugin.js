import { join } from "path";
import { readdirSync } from "fs";
import DynamicEntryPlugin from "webpack/lib/DynamicEntryPlugin";

class StaticCompilerPlugin {
  constructor(config) {
    const defaults = { sourceDir: "pages" };
    this.data = Object.assign(defaults, config);
  }

  get entries() {
    const path = join(__dirname, "..", this.data.sourceDir);
    return readdirSync(path);
  }

  static addEntry(compilation, context, name, entry) {
    return new Promise((resolve, reject) => {
      const dep = DynamicEntryPlugin.createDependency(`${name}/index.js`, name);
      compilation.addEntry(context, dep, name, err => {
        if (err) return reject(err);
        resolve();
      });
    });
  }

  apply(compiler) {
    compiler.hooks.make.tapAsync("StaticCompilerPlugin", (compilation, cb) => {
      const allEntries = this.entries.map(entry => {
        return StaticCompilerPlugin.addEntry(
          compilation,
          compiler.context,
          entry,
          `${this.data.sourceDir}/${entry}/index.js`
        );
      });

      Promise.all(allEntries)
        .then(() => cb())
        .catch(cb);
    });

    compiler.hooks.emit.tap("StaticCompilerPlugin", compilation => {
      debugger;
    });
  }
}

export default StaticCompilerPlugin;
