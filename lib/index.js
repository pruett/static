import _ from "lodash";
import path from "path";
import React from "react";
import ReactDOM from "react-dom/server";

// const getPageContents = path => require(`../src/pages${path}`);
//
const getPage = path => require(path)();
// const markup = data => {
//   console.log(data);
//   return `
//     <!DOCTYPE html>
//     <html>
//       <head><title>Webpack Static Plugin Example</title></head>
//       <body>
//         <p>this is body</p>
//         <script src="/main.js"></script>
//       </body>
//     </html>
//   `;
// };

const render = async (locals, callback) => {
  const staticBundle = _.find(locals.static, ["path", locals.path]);
  console.log("static bundle", staticBundle);
  const Page = awiait getPage(staticBundle.file);
  console.log("Page", Page);
  // const html = ReactDOM.renderToStaticMarkup(
  //   React.createElement(TermsOfUse, locals)
  // );
  console.log(locals);
  // return callback(null, `<!DOCTYPE html>${html}`);
};

export default render;
