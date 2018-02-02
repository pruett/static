require = require("@std/esm")(module);
require("@babel/register");

module.exports = require("./index.mjs").default;
