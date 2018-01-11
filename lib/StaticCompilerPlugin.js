import { join } from "path";
import { readdir } from "fs";
import DynamicEntryPlugin from "webpack/lib/DynamicEntryPlugin";

class StaticCompilerPlugin {
  constructor(config) {
    const defaults = { sourceDir: "pages" };
    this.data = Object.assign(defaults, config);
  }

  get entries() {
    const path = join(__dirname, "..", this.data.sourceDir);
    return new Promise((resolve, reject) => {
      readdir(path, (err, files) => {
        if (err) return reject(err);
        resolve(files);
      });
    });
  }

  addEntries(dep, compilation, context, name, entry) {
    return new Promise((resolve, reject) => {
      compilation.addEntry(context, dep, name, err => {
        if (err) return reject(err);
        resolve();
      });
    });
  }

  createDependencies(entries) {
    return new Promise((resolve, reject) => {
      const deps = entries.map(name => {
        return DynamicEntryPlugin.createDependency(`${name}/index.js`, name);
      });
      resolve(deps);
    });
  }

  log(data) {
    console.log(data);
  }

  apply(compiler) {
    // const getAllEntries = this.entries;

    compiler.hooks.make.tapAsync("StaticCompilerPlugin", (compilation, cb) => {
      // const allEntries =
      this.entries
        .then(allEntries =>
          Promise.all([allEntries, this.createDeps(allEntries)])
        )

        .then(({ dependencies, name }) => {
          return dependencies.map(dep =>
            this.addEntries(
              dep,
              compilation,
              compiler.context,
              name,
              `${name}/index.js`
            )
          );
        })
        .catch(err => console.error(`Error adding dynamic entry: ${err}`));

      debugger;

      // Promise.all(allEntries)
      //   .then(() => callback())
      //   .catch(callback);
    });

    compiler.hooks.emit.tap("StaticCompilerPlugin", compilation => {
      debugger;
    });
  }
}

export default StaticCompilerPlugin;
