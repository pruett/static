import React from "react";
import { render, hydrate } from "react-dom";
import Main from "./Main";
// import data from './data.json'

if (ENV === "development") {
  import("./data").then(contents =>
    console.log("Hot reloading initialData: ", contents.default)
  );
}

const DOM_CLIENT_HOOK = document.getElementById("Root");

hydrate(<Main initialData={window.__initialData__} />, DOM_CLIENT_HOOK);
