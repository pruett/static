const merge = require("webpack-merge");
const webpack = require("webpack");
const common = require("./webpack.config.common.js");

module.exports = merge(common, {
  mode: "development",

  output: {
    filename: "[name].bundle.js",
    publicPath: "/"
  },

  plugins: [new webpack.HotModuleReplacementPlugin()]
});
