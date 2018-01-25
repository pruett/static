const ReactDOMServer = require("react-dom/server");

class StaticCompilerPlugin {
  // this take a page
  // i.e. {page: 'hello-world'}
  constructor(config = {}) {
    const defaults = {};
    this.data = Object.assign(defaults, config);
  }

  apply(compiler) {
    compiler.hooks.emit.tap("StaticCompilerPlugin", compilation => {
      const allChunks = compilation.getStats().toJson().chunks;
    });
  }
}

module.exports = StaticCompilerPlugin;
