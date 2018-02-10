import React from "react";
import { render, hydrate } from "react-dom";
import { fetchData } from "../../lib/utils/dataFetchingUtils";
import Main from "./Main";

const DOM_CLIENT_HOOK = document.getElementById("Root");

if (ENV === "development") {
  import("./data").then(data => {
    fetchData(data.default).then(res => {
      render(<Main {...res} />, DOM_CLIENT_HOOK);
    });
  });
} else {
  hydrate(<Main />, DOM_CLIENT_HOOK);
}
