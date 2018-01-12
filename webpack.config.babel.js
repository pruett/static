import path from "path";
import webpack from "webpack";
import CleanWebpackPlugin from "clean-webpack-plugin";
import StaticCompilerPlugin from "./lib/StaticCompilerPlugin.js";

module.exports = env => {
  return {
    entry: {
      main: "./src/template.js"
    },

    output: {
      filename: "[name].[hash].bundle.js",
      chunkFilename: "[name].[hash].chunk.js",
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

    plugins: [new CleanWebpackPlugin(["dist"]), new StaticCompilerPlugin()]
  };
};
