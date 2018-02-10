const merge = require("webpack-merge");
const webpack = require("webpack");
const common = require("./webpack.config.common");

module.exports = merge(common, {
  mode: "development",

  target: "web",

  output: {
    filename: "[name].bundle.js",
    publicPath: "/"
  },

  plugins: [
    new webpack.DefinePlugin({
      ENV: JSON.stringify("development")
    }),
    new webpack.HotModuleReplacementPlugin()
  ]
});
