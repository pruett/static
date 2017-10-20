const trim = str => str.replace(/\s+/g, " ").trim();
const ƒ = bool => (left = "", right = "") => (bool ? left : right);
const µ = (strs, ...exps) => {
  // Trim template string literals.
  return trim(strs.reduce((acc, part, i) => acc + exps[i - 1] + part));
};

module.exports = {
  µ,
  ƒ,
  trim
};
