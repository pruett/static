const React = require("react/addons");
const GridWrapper = Component => {
  return (
    <div className="u-grid -maxed u-ma">
      <div className="u-grid__row">
        <div className="u-grid__col u-w12c">
          {Component}
        </div>
      </div>
    </div>
  );
};

GridWrapper.displayName = "GridWrapper";

module.exports = GridWrapper;
