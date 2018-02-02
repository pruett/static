const { resolve } = require("path");
const merge = require("webpack-merge");
const common = require("./webpack.config.common.js");
const StaticGeneratorPlugin = require("./lib/StaticGeneratorPlugin.js");

module.exports = merge(common, {
  mode: "production",

  target: "node",

  output: {
    path: resolve(__dirname, "dist"),
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js"
  },

  plugins: [new StaticGeneratorPlugin()]
});
