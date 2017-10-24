import React from "react";
import ReactDOM from "react-dom/server";

// const html = ReactDOM.render(
//   <h1>Hello, world</h1>,
//   document.getElementById("root")
// );

module.export = function render(html) {
  `<!doctype html>\n${html}`;
};
