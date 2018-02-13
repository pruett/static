import React from "react";
import { render, hydrate } from "react-dom";
import { fetchData } from "../../lib/utils/dataFetchingUtils";
import Main from "./Main";

const DOM_CLIENT_HOOK = document.getElementById("Root");

if (ENV === "development") {
  import("./data").then(contents => {
    fetchData(contents.default).then(initialData => {
      render(<Main initialData={initialData} />, DOM_CLIENT_HOOK);
    });
  });
}

// if (ENV === "production") {
//   hydrate(<Main initialData={window.__initialData__} />, DOM_CLIENT_HOOK);
// }
