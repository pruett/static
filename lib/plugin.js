"use strict";

// x. Loop over data
// x. Run each "entry"
// x. Create folder
// x. Create index.html in respective folder

function StaticRenderPlugin(options) {}

StaticRenderPlugin.prototype.apply = function(compiler) {
  compiler.plugin("emit", (cmpl, cb) => {
    debugger;
    cb();
  });

  compiler.plugin("done", () => {
    console.log("Done with static render plugin!");
  });
};

module.exports = StaticRenderPlugin;
