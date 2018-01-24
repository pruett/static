const merge = require("webpack-merge");
const StaticCompilerPlugin = require("./lib/StaticCompilerPlugin.js");
const common = require("./webpack.config.common.js");

module.exports = merge(common, {
  devtool: "source-map",

  output: {
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js"
  },

  plugins: [new StaticCompilerPlugin()]
});
