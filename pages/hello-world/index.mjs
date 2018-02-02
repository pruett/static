import { AppContainer } from "react-hot-loader";
import React from "react";
import ReactDOM from "react-dom";
import Main from "./Main";

const rootEl = document.getElementById("root");
const render = Component =>
  ReactDOM.render(
    <AppContainer>
      <Main />
    </AppContainer>,
    rootEl
  );

render(Main);
if (module.hot) module.hot.accept("./Main", () => render(Main));
