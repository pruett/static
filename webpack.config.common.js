const path = require("path");
const webpack = require("webpack");
const CleanWebpackPlugin = require("clean-webpack-plugin");

module.exports = {
  context: path.resolve(__dirname, "pages"),

  /*
  entry: {
    this is set dynamically
  */

  output: {
    path: path.resolve(__dirname, "dist")
  },

  resolve: {
    extensions: [".js", ".json", ".jsx"]
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: ["babel-loader"]
      }
    ]
  },

  plugins: [new CleanWebpackPlugin(["dist"])]
};
