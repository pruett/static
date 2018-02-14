const { resolve } = require("path");
const webpack = require("webpack");
const merge = require("webpack-merge");
const common = require("./webpack.config.common.js");
const CleanWebpackPlugin = require("clean-webpack-plugin");

module.exports = merge(common, {
  mode: "production",

  output: {
    path: resolve(__dirname, "dist"),
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js"
  },

  plugins: [new CleanWebpackPlugin(["dist"])]
});
