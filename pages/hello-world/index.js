import React from "react";
import ReactDOM from "react-dom";
import Main from "./Main";

const page = <Main />;
const CLIENT_MOUNT = document.getElementById("CLIENT_MOUNT");

RENDER_ENV === "server"
  ? ReactDOM.hydrate(page, CLIENT_MOUNT)
  : ReactDOM.render(page, CLIENT_MOUNT);
