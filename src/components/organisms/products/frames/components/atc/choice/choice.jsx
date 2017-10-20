const React = require("react/addons");

const CLASSES = {
  button:
    "u-reset--button c-atc__button u-pr u-color-bg--white u-br4 u-tal u-p24 u-bc--light-gray-alt-1 u-bw1 u-bss u-w100p u-mb10 u-mb18--900 u-pt18 u-pb18",
  row: "u-grid__row u-pr",
  check: "u-pa u-t0 u-l0 u-pl2 u-pl12--900 u-pl24--1200 u-pt2 u-pt4--900",
  col: "u-pr u-grid__col u-l1c u-w11c u-w10c--600",
  wrapper: "u-pr u-db",
  title: "u-reset u-fws u-fs16 u-ffss u-fs18--600 u-mb3",
  description: "u-reset u-fs16 u-ffss u-color--dark-gray-alt-3 u-lh24",
  price:
    "u-tar u-pa u-r0 u-t0 u-ffss u-fs16 u-fs18--600 u-fws u-pr12 u-pr18--900",
};

const Choice = ({ name, description, price, isActive, onClick }) => {
  return (
    <button
      onClick={onClick}
      className={`${CLASSES.button} ${isActive ? "-active" : ""}`}
    >
      <span className={CLASSES.row}>
        <span className={CLASSES.check}>
          <svg width="24" height="24" title="Checkmark" viewBox={"0 0 26 26"}>
            <g transform="translate(1, 1)" fill="none">
              <circle
                className={`u-fill--${isActive ? "blue" : "light-gray"}`}
                strokeWidth="1.25"
                cx="12"
                cy="12"
                r="12"
              />
              <polyline
                strokeWidth="1.5"
                strokeLinecap="round"
                className="u-stroke--white"
                points="7 11.6 10.13 15.2 16.39 8"
              />
            </g>
          </svg>
        </span>
        <span className={CLASSES.col}>
          <span className={CLASSES.wrapper}>
            <h1 className={CLASSES.title} children={name} />
            <p
              className={CLASSES.description}
              children={description}
            />
          </span>
        </span>
        <span className={CLASSES.price} children={price} />
      </span>
    </button>
  );
};

Choice.propTypes = {
  name: React.PropTypes.string,
  description: React.PropTypes.string,
  price: React.PropTypes.string,
  isActive: React.PropTypes.bool,
  onClick: React.PropTypes.func,
};

module.exports = Choice;
