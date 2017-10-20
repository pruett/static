function StaticRenderPlugin(options) {
  console.log("my options", options);
}

StaticRenderPlugin.prototype.apply = compiler => {
  compiler.plugin("done", () => console.log("Hello Kevin"));
};

module.exports = StaticRenderPlugin;
