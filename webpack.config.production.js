const merge = require("webpack-merge");
const common = require("./webpack.config.common.js");

module.exports = merge(common, {
  mode: "production",

  output: {
    filename: "[name].[hash].bundle.js",
    chunkFilename: "[name].[hash].chunk.js"
  }

  /*
   * output: {
   *   path: path.resolve(__dirname, "dist")
   *   path: --> set dynamically
   * },
  */

  /*
   * plugins: [
   *   --> this is set dynamically
   * ]
  */
});
