import fs from "fs";
import path from "path";
import express from "express";
import minimist from "minimist";
import http from "http";
import webpack from "webpack";
import webpackConfig from "../../webpack.config.development";
import markup from "./index.html.js";
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

const compiler = webpack(
  Object.assign({}, webpackConfig, {
    entry: {
      main: [
        "webpack-hot-middleware/client?overlay=true&reload=true",
        `./${page}`
      ]
    }
  })
);

app.use(
  require("webpack-dev-middleware")(compiler, {
    noInfo: true,
    publicPath: webpackConfig.output.publicPath
  })
);
app.use(require("webpack-hot-middleware")(compiler));

app.get("*", (req, res) => {
  res.send(
    markup({
      title: "my cool title",
      bundle: "main.bundle.js"
    })
  );
});

const server = http.createServer(app);
const port = 8080;
server.listen(port, "0.0.0.0", err => {
  if (err) console.log(err);
  console.info(`🍒 Listening on port ${port}.`);
});
