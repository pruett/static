const fs = require("fs");
const path = require("path");
const { merge } = require("lodash");
const webpack = require("webpack");
const webpackConfig = require("../../webpack.config.production");
const pages = fs.readdirSync(path.join(__dirname, "..", "..", "pages"));

pages
  ? void 0
  : (function() {
      throw new Error("no /pages dir");
    })();

const entries = pages.reduce((acc, x) => {
  acc[x] = `./${x}`;
  return acc;
}, {});

const config = merge(webpackConfig, {
  entry: entries
});

webpack(config, (err, stats) => {
  if (err || stats.hasErrors()) console.error("Error:", err);

  console.log("Done building!");
});
