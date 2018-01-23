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
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js",
    path: path.resolve(__dirname, "dist"),
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
