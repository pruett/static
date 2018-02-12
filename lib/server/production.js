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
import StaticGeneratorPlugin from "../plugins/StaticGeneratorPlugin";

const pagesDir = fs.readdirSync(path.join(__dirname, "..", "..", "pages"));

pagesDir
  ? void 0
  : (function() {
      throw new Error("no /pages dir");
    })();

const entries = pagesDir.reduce((acc, x) => {
  acc[x] = `./${x}`;
  return acc;
}, {});

const config = merge(webpackConfig, {
  entry: entries,
  plugins: [new StaticGeneratorPlugin()]
});

webpack(config, (err, stats) => {
  if (err || stats.hasErrors()) console.error("Error:", err);

  console.log("Done building!");
});
