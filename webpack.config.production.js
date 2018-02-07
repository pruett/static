const { resolve } = require("path");
const webpack = require("webpack");
const merge = require("webpack-merge");
const common = require("./webpack.config.common.js");

module.exports = merge(common, {
  mode: "production",

  target: "node",

  output: {
    path: resolve(__dirname, "dist"),
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js"
  },

  plugins: [
    new webpack.DefinePlugin({
      RENDER_ENV: JSON.stringify("server")
    })
  ]
});
