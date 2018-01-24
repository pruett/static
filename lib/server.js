const fs = require("fs");
const path = require("path");
const express = require("express")();
const http = require("http");
const webpack = require("webpack");
const React = require("react");
const ReactDOM = require("react-dom");
const webpackConfig = require("../webpack.config");
const port = 8080;
const args = require("minimist")(process.argv.slice(2));
const page = args.p || args.page;

// What does this script have to do?
// 1. Accept a valid page
//    a. valid means it lives in 'pages' directory
//    b. and has a root index.js file that we can read
// 2. Add page's index.js as our entry file
// ---> 3. Create page markup with data
//    a. Include webpack's bundles and chunks in the markup
// 4. Output .html, .css, and. js file(s) to dist/<page>/<file>.<ext>
// 5. Deploy!!

const validatePage = page => {
  fs.existsSync(path.join(__dirname, "..", "pages", page, "index.js"))
    ? void 0
    : (function() {
        throw new Error(
          `Please ensure that a ${page} directory exists inside the pages folder and that it contains an index.js file.`
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
      main: ["webpack-hot-middleware/client", `./${page}/index.js`]
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
  const markup = require("../src/index.html")({
    title: "my cool title",
    bundle: "main.bundle.js"
  });
  res.send(markup);
});

const server = http.createServer(express);
server.listen(port, "0.0.0.0", err => {
  if (err) console.log(err);
  console.info(`🍒 Listening on port ${port}.`);
});
