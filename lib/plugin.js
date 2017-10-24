"use strict";

// x. Loop over data
// x. Run each "entry"
// x. Create folder
// x. Create index.html in respective folder
const SingleEntryDependency = require("webpack/lib/dependencies/SingleEntryDependency.js");

function StaticRenderPlugin(data = []) {
  this.data = data;
}

StaticRenderPlugin.prototype.apply = function(compiler) {
  const plugin = this;

  compiler.plugin("make", (compilation, err) => {
    compilation.addEntry(
      compiler.context,
      new SingleEntryDependency(plugin.data[0].entry),
      "termsOfUse",
      err
    );
  });
};

module.exports = StaticRenderPlugin;
