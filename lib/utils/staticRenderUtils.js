require("@babel/register");

import React from "react";
import { renderToString } from "react-dom/server";

const renderPageMarkup = (file, data = {}) => {
  const props = typeof data === "string" ? JSON.parse(data) : props;

  console.log(
    renderToString(React.createElement(require(file).default, props, null))
  );

  debugger;

  return renderToString(
    React.createElement(require(file).default, props, null)
  );
};

const renderFullPageDocument = ({
  title = "Warby Parker",
  initialData = null,
  html = staticBolt,
  bundles = []
} = {}) => {
  const scripts = Boolean(bundles.length)
    ? bundles.map(x => `<script src="./${x}"></script>`).join("")
    : "";

  debugger;
  //TODO Handle css
  return `<!doctype html>
<html>
  <head>
    <title>${title}</title>${
    initialData
      ? `<script>window.__initialData__ = ${initialData}</script>`
      : ""
  }
  </head>
  <body>
    <div id='Root'>${html}</div>
    ${scripts}
  </body>
</html>`;
};

const staticBolt = `
      <div style="width: 15vw; position: fixed; top: 0; left: 0; display: flex; bottom: 0; right: 0; margin: auto;">
        <svg width="100%" viewBox="0 0 349 226" xmlns="http://www.w3.org/2000/svg">
          <g fill="#00A2E1" fill-rule="nonzero">
            <path class="brackets" d="M327.776 125.87l-55.81-27.433c-2.646-1.301-3.725-4.475-2.409-7.09 1.316-2.615 4.528-3.68 7.174-2.38l69.722 34.272a3.156 3.156 0 0 1-.07 5.716l-69.713 32.18c-2.678 1.236-5.862.093-7.113-2.553-1.25-2.646-.093-5.793 2.584-7.03l55.635-25.681zM20.53 124.114l55.81 27.434c2.646 1.301 3.724 4.475 2.408 7.09-1.316 2.615-4.528 3.68-7.174 2.38L1.852 126.746a3.156 3.156 0 0 1 .071-5.716l69.712-32.18c2.678-1.236 5.862-.093 7.113 2.553 1.25 2.646.094 5.793-2.584 7.03L20.53 124.113z" fill-opacity=".456"/>
            <path class="bolt" d="M178.527 74.66l63.298-13.724a1 1 0 0 1 1.013 1.577L120.634 225.59a1 1 0 0 1-1.683-1.071L185.05 100.79l-65.364 17.456a1 1 0 0 1-1.034-1.597L212.453 1.285a1 1 0 0 1 1.673 1.073L178.527 74.66z"/>
          </g>
        </svg>
        <script>
          var bolt = document.querySelector(".bolt");
          var brackets = document.querySelector(".brackets");
          var boltOptions = {
            iterations: Infinity,
            direction: 'alternate',
            duration: 400,
            fill: 'forwards',
            easing: 'ease-in-out',
          };
          var bracketOptions = {
            iterations: Infinity,
            direction: 'alternate',
            duration: 400,
            fill: 'forwards',
            easing: 'ease-in-out',
          };
          var boltFrames = [{
              transform: 'translateY(10px) scale(0.85) rotate(10deg)',
              transformOrigin: '50% 50%'
            },
            {
              transform: 'translateY(-10px)  scale(1.05) rotate(-25deg)',
              transformOrigin: '50% 50%'
            }
          ];
          var bracketFrames = [{
              transform: 'scaleY(1.25) scaleX(0.75)',
              transformOrigin: '50% 50%',
            },
            {
              transform: 'scaleY(1) scaleX(0.95)',
              transformOrigin: '50% 50%',
              filter: 'blur(0)',
              opacity: 1
            }
          ];
          bolt.animate(boltFrames, boltOptions)
          brackets.animate(bracketFrames, bracketOptions)
        </script>
      </div>`;

export { renderPageMarkup, renderFullPageDocument };
