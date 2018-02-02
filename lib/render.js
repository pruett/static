require("babel-register");

const React = require("react");
const { renderToString, renderToStaticMarkup } = require("react-dom/server");

const render = file => {
  const markup = React.createElement(require(file).default);
  debugger;
  return markup;
};

module.exports = render;
