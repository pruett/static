const path = require("path");
const webpack = require("webpack");

module.exports = {
  context: path.resolve(__dirname, "pages"),

  /*
   * entry: {
   *   --> this is set dynamically
   * },
  */

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
  }
};
