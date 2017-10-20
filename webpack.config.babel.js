import path from "path";
import CleanWebpackPlugin from "clean-webpack-plugin";
import StaticRenderPlugin from "./lib/plugin.js";
import data from "./lib/data.js";

const staticChunk = "static";

module.exports = {
  entry: {
    [staticChunk]: "./lib/index.js"
  },

  output: {
    filename: "[name].[hash].bundle.js",
    path: path.resolve(__dirname, "dist")
  },

  resolve: {
    extensions: [".js", ".json", ".jsx", ".cjsx"]
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: ["babel-loader"]
      },
      {
        test: /\.cjsx$/,
        exclude: /node_modules/,
        use: ["coffee-loader", "cjsx-loader"]
      }
    ]
  },

  plugins: [
    new CleanWebpackPlugin(["dist"]),
    new StaticRenderPlugin({ data: data })
  ]
};
