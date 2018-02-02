/*
 * find page
 * add entry and plugin dynamically
 */
const args = require("minimist")(process.argv.slice(2));
const page = args.p || args.page;

const validatePage = page => {
  fs.existsSync(path.join(__dirname, "..", "..", "pages", page, "index.js"))
    ? void 0
    : (function() {
        throw new Error(
          `Please ensure that a ${page} directory exists inside the top-level /pages directory, and that *it* contains an index.js file.`
        );
      })();
};

page
  ? validatePage(page)
  : (function() {
      throw new Error(
        "Please provide a page argument with -p or --page\n example: -p my-page"
      );
    })();
