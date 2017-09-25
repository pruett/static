const path = require("path");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const StaticSiteGeneratorPlugin = require("static-site-generator-webpack-plugin");
const data = require("./lib/data.js");

const staticChunk = "static";

module.exports = {
  entry: {
    [staticChunk]: "./lib/index.js",
    "terms-of-use": "./src/pages/terms_of_use/client.js"
  },

  output: {
    filename: "[name].[hash].bundle.js",
    path: path.resolve(__dirname, "dist"),
    libraryTarget: "umd"
  },

  resolve: {
    extensions: [".js", ".json", ".jsx", ".cjsx"]
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      }
    ],
    rules: [
      {
        test: /\.cjsx$/,
        exclude: /node_modules/,
        use: ["coffee-loader", "cjsx-loader"]
      }
    ]
  },

  plugins: [
    new CleanWebpackPlugin(["dist"]),
    new StaticSiteGeneratorPlugin({
      entry: staticChunk,
      paths: data.static.map(x => x.path),
      locals: data,
      globals: { window: {} }
    })
  ]
};
