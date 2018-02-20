/*
 *
 * Kick off development server for a particular page
 *
*/
import fetch from "isomorphic-fetch";
import fs from "fs";
import path from "path";
import express from "express";
import minimist from "minimist";
import http from "http";
import webpack from "webpack";
import merge from "webpack-merge";
import webpackConfig from "../../webpack/development.config";
import * as utils from "../utils";
const args = minimist(process.argv.slice(2));
const page = args.p || args.page;
const app = express();

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

const dataPath = path.join(__dirname, "..", "..", "pages", page, "data.js");
const componentPath = path.join(
  __dirname,
  "..",
  "..",
  "pages",
  page,
  "Main.js"
);
const configPath = path.join(__dirname, "..", "..", "pages", page, "config.js");

import(configPath).then(contents => utils.fetchData(contents.default));

// const compiler = webpack(
//   merge(webpackConfig, {
//     entry: {
//       main: [
//         "webpack-hot-middleware/client?overlay=true&reload=true",
//         `./${page}`
//       ]
//     }
//   })
// );

// app.use(
//   require("webpack-dev-middleware")(compiler, {
//     logLevel: "warn",
//     publicPath: webpackConfig.output.publicPath
//   })
// );
// app.use(require("webpack-hot-middleware")(compiler));

// app.get("*", async (req, res) => {
//   const initialData = await utils.fetchComponentData(dataPath);
//   const html = utils.renderPageMarkup(componentPath, initialData);
//   const bundles = ["main.bundle.js"];

//   res.send(
//     utils.renderFullPageDocument({
//       html,
//       bundles,
//       initialData: JSON.stringify(initialData)
//     })
//   );
// });

// const server = http.createServer(app);
// const port = 8080;
// server.listen(port, "0.0.0.0", err => {
//   if (err) console.log(err);
//   console.info(`\n🍒 Server started on port ${port}.\n`);
// });

// compiler.hooks.done.tap("done", () => {
//   Object.keys(require.cache).forEach(function(id) {
//     if (/[\/\\]pages[\/\\]/.test(id)) delete require.cache[id];
//   });
// });
