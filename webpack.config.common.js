const { resolve } = require("path");
const webpack = require("webpack");

module.exports = {
  context: resolve(__dirname, "pages"),

  // entry: { --> this is set dynamically },

  output: {
    path: resolve(__dirname, "dist")
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: ["babel-loader"]
      }
    ]
  }
};
