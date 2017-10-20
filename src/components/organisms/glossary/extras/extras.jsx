const React = require("react/addons");

const GlossaryStatus = ({ classes, activeLetter }) => {
  return (
    <div className={classes.activeContent}>
      <span className={classes.activeLetter}>
        {activeLetter ? activeLetter : "Select a letter"}
      </span>
      <svg
        className={classes.activeArrow}
        width="11"
        height="7"
        viewBox="0 0 11 7"
        xmlns="http://www.w3.org/2000/svg"
      >
        <g className={classes.arrowDown}>
          <path d="M5.5 6L0 1M11 1L5.5 6" />
        </g>
      </svg>
    </div>
  );
};

const BackToTop = ({ classes, scrollToTop }) => {
  return (
    <button className={classes.btnBackToTop} onClick={scrollToTop}>
      <svg
        width="15"
        height="20"
        viewBox="0 0 15 20"
        xmlns="http://www.w3.org/2000/svg"
      >
        <g className={classes.arrowBackToTop}>
          <path d="M7.5 19.5v-18M7.5.5l7 6M.5 6.5l7-6" />
        </g>
      </svg>
    </button>
  );
};

export { GlossaryStatus, BackToTop };
