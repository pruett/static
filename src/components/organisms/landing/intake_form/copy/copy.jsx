const React = require("react/addons");

const { µ } = require("components/utilities/classNames");
require("./copy.scss");

const BLOCK_CLASS = "c-prescription-services-copy";
const CLASSES = {
  title: µ`
    u-reset
    u-fws u-fs30 u-fs40--900 u-ffs
    u-mb24 u-mb18--900
  `,
  body: "u-fs16 u-fs18--900 u-ffss u-color--dark-gray-alt-3",
  eyebrow: "u-db u-fs12 u-ffss u-ttu u-ls3 u-color--dark-gray u-mb12 u-fws",
  copy: "u-tac u-mw600 u-p24 u-p36--900 u-p0--900 u-ma",

  main: "u-color-bg--light-gray-alt-5 u-pb36 u-pt36",
  section: µ`
    ${BLOCK_CLASS}__section
    u-pr u-mb66 u-mb72--600 u-mb0--900
    u-mw1440 u-ma
    u-df
    u-tal
    u-oh
    `,

  row: "u-grid__row",

  col: µ`
  u-grid__col -col-middle
  u-w12c u-w5c--900
  u-tac u-tal--900`,

  link: "u-fs16 u-fws",

  strong: "u-fws",

  imgChartDesktop: `u-dn u-db--900`,
  imgChartMobile: `u-db u-dn--900`,

  image: µ`
    u-vat u-dib
    u-pa--900 u-w6c
    u-t0 u-center-y--900
    u-mb36 u-mb0--900
  `,

  borderBottom: µ`
    u-bw0 u-bw0--900
    u-bbw1 u-bc--light-gray-alt-1 u-bss
  `,

  get imageCard() {
    return µ`
      ${this.image}
      u-l1c--900
      u-w6c
      u-w5c--900`;
  },

  grid: "u-grid -maxed u-ma u-mw1440 u-w12c",

  get gridRightText() {
    return µ`
      ${this.grid}
      u-tar--900
    `;
  }
};

module.exports = ({handleClickJump}) => {
  return (
    <div>
      <section className={CLASSES.section}>
        <div className={CLASSES.gridRightText}>
          <div className={CLASSES.row}>
            <div className={CLASSES.col}>
            </div>
          </div>
        </div>
      </section>

      <section className={CLASSES.section}>
        <div className={CLASSES.grid}>
          <div className={CLASSES.row}>
            <div className={CLASSES.col}>
            </div>
          </div>
        </div>
      </section>
      <section className={CLASSES.section}>
        <div className={CLASSES.gridRightText}>
          <div className={CLASSES.row}>
            <div className={CLASSES.col}>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};
