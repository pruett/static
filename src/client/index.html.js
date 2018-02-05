const markup = ({ title = "blah", app = "", bundle = "" } = {}) => `
  <!doctype>
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body>
      <div id='root'>${app}</div>
      <script src=${bundle}></script>
    </body>
  </html>
`;

export default markup;
