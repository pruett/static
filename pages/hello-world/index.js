import React from "react";
import ReactDOM from "react-dom";
import Main from "./Main";

const CLIENT_MOUNT = document.getElementById("CLIENT_MOUNT");

RENDER_ENV === 'server'
  ? ReactDOM.hydrate(<Main />, CLIENT_MOUNT)
  : ReactDOM.render(<Main />, CLIENT_MOUNT);
