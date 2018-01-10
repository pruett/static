const SingleEntryDependency = require("webpack/lib/dependencies/SingleEntryDependency.js");
const DynamicEntryPlugin = require("webpack/lib/DynamicEntryPlugin");

class StaticCompilerPlugin {
  constructor() {
    this.entries = [
      { entry: "./src/1.js", name: "one" },
      { entry: "./src/2.js", name: "two" }
    ];
  }

  static addEntry(compilation, context, name, entry) {
    return new Promise((resolve, reject) => {
      const dep = DynamicEntryPlugin.createDependency(entry, name);
      compilation.addEntry(context, dep, name, err => {
        if (err) return reject(err);
        resolve();
      });
    });
  }

  apply(compiler) {
    compiler.hooks.make.tapAsync(
      "StaticCompilerPlugin",
      (compilation, callback) => {
        const allEntries = this.entries.map(({ entry, name }) => {
          return StaticCompilerPlugin.addEntry(
            compilation,
            compiler.context,
            name,
            entry
          );
        });

        Promise.all(allEntries)
          .then(() => callback())
          .catch(callback);
      }
    );

    compiler.hooks.emit.tap("StaticCompilerPlugin", compilation => {
      debugger;
    });
  }
}

export default StaticCompilerPlugin;
