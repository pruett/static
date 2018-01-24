module.exports = ({ bundle, title }) => `
  <!doctype>
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body>
      <div id='root'></div>
      <script src=${bundle}></script>
    </body>
  </html>
`;
