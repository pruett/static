const { merge, kebabCase } = require("lodash");
const fs = require("fs");
const path = require("path");
const express = require("express")();
const http = require("http");
const webpack = require("webpack");
const webpackConfig = require("../../webpack.config.production");
const StaticCompilerPlugin = require("../plugins/StaticCompilerPlugin");

/*
 * find page
 * add entry and plugin dynamically
 */
const args = require("minimist")(process.argv.slice(2));
const page = args.p || args.page;

const validatePage = page => {
  fs.existsSync(path.join(__dirname, "..", "..", "pages", page, "index.js"))
    ? void 0
    : (function() {
        throw new Error(
          `Please ensure that a ${page} directory exists inside the top-level /pages directory, and that *it* contains an index.js file.`
        );
      })();
};

page
  ? validatePage(page)
  : (function() {
      throw new Error(
        "Please provide a page argument with -p or --page\n example: -p my-page"
      );
    })();

const config = merge(webpackConfig, {
  entry: { main: `./${page}` },
  output: {
    path: path.resolve(__dirname, "../../dist", kebabCase(page))
  },
  plugins: [new StaticCompilerPlugin({ page })]
});

console.log(config);

webpack(config, (err, stats) => {
  if (err || stats.hasErrors()) console.error("Error:", err);

  console.log(
    ` Done building! Your files are located here: ${path.resolve(
      __dirname,
      "../../dist",
      kebabCase(page)
    )}`
  );
});
