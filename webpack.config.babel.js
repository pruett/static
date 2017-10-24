import path from "path";
import webpack from "webpack";
import CleanWebpackPlugin from "clean-webpack-plugin";
import StaticRenderPlugin from "./lib/plugin.js";
import pages from "./lib/data.js";
import { BundleAnalyzerPlugin } from "webpack-bundle-analyzer";

const staticChunk = "static";

module.exports = {
  entry: {
    [staticChunk]: "./lib/index.js"
  },

  output: {
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js",
    path: path.resolve(__dirname, "dist")
  },

  resolve: {
    alias: {
      components: path.resolve(__dirname, "src/components"),
      backbone: "exoskeleton"
    },
    extensions: [".js", ".json", ".jsx", ".cjsx", ".coffee"]
  },

  externals: {
    jquery: "jQuery"
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
      },
      {
        test: /\.coffee$/,
        exclude: /node_modules/,
        use: "coffee-loader"
      },
      {
        test: /\.scss$/,
        exclude: [/node_modules/],
        use: [
          "style-loader",
          "css-loader",
          "sass-loader",
          {
            loader: "postcss-loader",
            options: {
              parser: "postcss-scss",
              plugins: loader => [require("autoprefixer")()]
            }
          }
        ]
      },
      {
        test: /.*\.(gif|png|jpe?g)$/i,
        exclude: /node_modules/,
        use: { loader: "url-loader", options: { limit: 10000 } }
      }
    ]
  },

  plugins: [
    // new BundleAnalyzerPlugin(),
    new CleanWebpackPlugin(["dist"]),
    new webpack.optimize.CommonsChunkPlugin({
      name: "common"
    }),
    new StaticRenderPlugin(pages)
  ]
};
