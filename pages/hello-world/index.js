import React from "react";
import ReactDOM from "react-dom";
import Main from "./Main";

const rootEl = document.getElementById("root");
const render = Component => ReactDOM.render(<Main />, rootEl);

render(Main);
