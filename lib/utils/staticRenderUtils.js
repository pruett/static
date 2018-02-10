require("@babel/register");

import React from "react";
import { renderToString } from "react-dom/server";
import { fetchData } from "./dataFetchingUtils";

const renderStringifiedMarkup = (file, props) => {
  renderToString(React.createElement(require(file).default, props, null));
};

const renderFullPageMarkup = ({
  title = "Warby Parker",
  html = "client is loading data...",
  bundles = []
} = {}) => {
  const scripts = Boolean(bundles.length)
    ? bundles.map(x => `<script src="${x}"></script>`).join("")
    : "";

  //TODO Handle css
  return `<!doctype html>
<html>
  <head>
    <title>${title}</title>
  </head>
  <body>
    <div id='Root'>${html}</div>
    ${scripts}
  </body>
</html>`;
};

export { renderFullPageMarkup, renderStringifiedMarkup };
