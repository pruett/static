/*
 *
 * Add all folders in /pages directory as entrypoints
 *
*/
import fs from "fs";
import path from "path";
import merge from "webpack-merge";
import webpack from "webpack";
import webpackConfig from "../../webpack.config.production";
import StaticGeneratorPlugin from "../../lib/StaticGeneratorPlugin";

const pages = fs.readdirSync(path.join(__dirname, "..", "..", "pages"));

console.log("hello");
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
  entry: entries,
  plugins: [new StaticGeneratorPlugin()]
});

console.log(config);

webpack(config, (err, stats) => {
  if (err || stats.hasErrors()) console.error("Error:", err);

  console.log("Done building!");
});
