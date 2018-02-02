require("babel-register");

const { join } = require("path");
const { readdirSync } = require("fs");
const DynamicEntryPlugin = require("webpack/lib/DynamicEntryPlugin");
const React = require("react");
const { renderToString, renderToStaticMarkup } = require("react-dom/server");
const render = require("./render");

class StaticGeneratorPlugin {
  constructor(config = {}) {
    const defaults = { sourceDir: "pages" };
    this.data = Object.assign(defaults, config);
  }

  // get filePath() {
  //   return join(__dirname, "..", this.data.sourceDir);
  // }

  // get entries() {
  //   return readdirSync(this.filePath);
  // }

  // static addEntry(compilation, context, chunkName, filename) {
  //   return new Promise((resolve, reject) => {
  //     const dep = DynamicEntryPlugin.createDependency(filename, chunkName);
  //     compilation.addEntry(context, dep, chunkName, err => {
  //       if (err) return reject(err);
  //       resolve();
  //     });
  //   });
  // }

  apply(compiler) {
    // compiler.hooks.make.tapAsync("StaticGeneratorPlugin", (compilation, cb) => {
    //   // Loop over folders inside <sourceDir>
    //   // and add their associated index.js files
    //   // as entrypoints
    //   const allEntries = this.entries.map(chunkName => {
    //     debugger;
    //     return StaticGeneratorPlugin.addEntry(
    //       compilation,
    //       compiler.context,
    //       chunkName,
    //       `./${chunkName}/index.js`
    //     );
    //   });

    //   Promise.all(allEntries)
    //     .then(() => cb())
    //     .catch(cb);
    // });

    compiler.hooks.emit.tap("StaticGeneratorPlugin", compilation => {
      const allChunks = compilation.getStats().toJson().chunks;

      render(
        join(__dirname, "..", this.data.sourceDir, "hello-world", "index.js")
      );

      // static render with reactDOM
      // compilation.assets[`${this.data[0].outputFolder}/index.html`] = {
      //   source: () => `<!doctype html>\n<div>hello</div>`,
      //   size: () => 10
      // };
    });
  }
}

module.exports = StaticGeneratorPlugin;
