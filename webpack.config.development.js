const merge = require("webpack-merge");
const webpack = require("webpack");
const common = require("./webpack.config.common");

module.exports = merge(common, {
  mode: "development",

  target: "web",

  entry: { main: "../src/index.js" },

  output: {
    filename: "[name].bundle.js",
    publicPath: "/"
  },

  plugins: [
    new webpack.DefinePlugin({
      RENDER_ENV: JSON.stringify("client")
    }),
    new webpack.HotModuleReplacementPlugin()
  ]
});
