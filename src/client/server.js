const fs = require("fs");
const path = require("path");
const express = require("express")();
const http = require("http");
const webpack = require("webpack");
const webpackConfig = require("../../webpack.config.development");

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

const compiler = webpack(
  Object.assign({}, webpackConfig, {
    entry: {
      main: [
        "react-hot-loader/patch",
        "webpack-hot-middleware/client?overlay=true&reload=true",
        `./${page}`
      ]
    }
  })
);

express.use(
  require("webpack-dev-middleware")(compiler, {
    noInfo: true,
    publicPath: webpackConfig.output.publicPath
  })
);
express.use(require("webpack-hot-middleware")(compiler));

express.get("*", (req, res) => {
  const markup = require("../index.html")({
    title: "my cool title",
    bundle: "main.bundle.js"
  });
  res.send(markup);
});

const server = http.createServer(express);
const port = 8080;
server.listen(port, "0.0.0.0", err => {
  if (err) console.log(err);
  console.info(`🍒 Listening on port ${port}.`);
});
