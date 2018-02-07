const renderMarkup = ({
  title = "Warby Parker",
  html = "",
  bundles = []
} = {}) => {
  const scripts = Boolean(bundles.length)
    ? bundles.map(x => `<script src="${x}"></script>`).join()
    : "";

  return `
    <!doctype html>
    <html>
      <head>
        <title>${title}</title>
      </head>
      <body>
        <div id='CLIENT_MOUNT'>${html}</div>
        ${scripts}
      </body>
    </html>
  `;
};

export default renderMarkup;
