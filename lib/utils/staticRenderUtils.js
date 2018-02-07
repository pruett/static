require("@babel/register");

import React from "react";
import { renderToString } from "react-dom/server";

const renderStringifiedMarkup = (file, props = {}) => {
  const el = React.createElement(require(file).default, props, null);
  const markup = renderToString(el);
  return markup;
};

const renderFullPageMarkup = ({
  title = "Warby Parker",
  html = "",
  bundles = []
} = {}) => {
  const scripts = Boolean(bundles.length)
    ? bundles.map(x => `<script src="${x}"></script>`).join("")
    : "";

  //TODO Inject css links
  return `<!doctype html>
<html>
  <head>
    <title>${title}</title>
  </head>
  <body>
    <div id='CLIENT_MOUNT'>${html}</div>
    ${scripts}
  </body>
</html>`;
};

export { renderFullPageMarkup, renderStringifiedMarkup };
