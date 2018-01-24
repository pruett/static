const path = require("path");
const webpack = require("webpack");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const StaticCompilerPlugin = require("./lib/StaticCompilerPlugin.js");

module.exports = {
  context: path.resolve(__dirname, "pages"),
  /*
  entry: {
    this is set dynamically
  */
  output: {
    path: path.resolve(__dirname, "dist"),
    // filename: "[name].[hash].bundle.js",
    filename: "[name].bundle.js",
    // chunkFilename: "[name].[hash].chunk.js",
    publicPath: "/"
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

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new CleanWebpackPlugin(["dist"])
    // new StaticCompilerPlugin()
  ]
};
