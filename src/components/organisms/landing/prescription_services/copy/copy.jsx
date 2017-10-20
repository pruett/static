const React = require("react/addons");
const Devices = require("components/organisms/landing/prescription_services/devices/devices");
const Picture = require("components/atoms/images/picture/picture");

const { µ, ƒ } = require("components/utilities/classNames");
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
  devices: `${BLOCK_CLASS}__devices u-oh`,

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

  get imageDevices() {
    return µ`
      ${this.image}
      ${this.borderBottom}
      u-l0--900
      u-w12c
      u-w7c--900`;
  },

  get imageChart() {
    return µ`
      ${this.image}
      ${this.borderBottom}
      u-r0--900
      u-w12c
      u-w5c--900`;
  },

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
              <span className={CLASSES.eyebrow} children="FIRST THINGS FIRST" />
              <h1 className={CLASSES.title} children="Let’s see if you’re eligible" />
              <div className={CLASSES.imageDevices}>
                <div className={CLASSES.devices}>
                  <Devices />
                </div>
              </div>
              <div className={CLASSES.body}>
                Down below, answer some questions (about your location, eye health, age, etc.) and
                we’ll let you know if this is available to you.
                <br />
                <br />
                <a href="#survey" onClick={handleClickJump} className={CLASSES.strong}>
                  Start answering
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className={CLASSES.section}>
        <div className={CLASSES.grid}>
          <div className={CLASSES.row}>
            <div className={CLASSES.col}>
              <span className={CLASSES.eyebrow} children="If you are eligible…" />
              <h1
                className={CLASSES.title}
                children="Come into the store to take a few vision tests"
              />
              <div className={CLASSES.imageChart}>
                <img
                  src="https://i.warbycdn.com/v/c/assets/prescription-services/image/rx-chart/1/b9a92612c3.png"
                  className={CLASSES.imgChartDesktop}
                />
                <img
                  src="https://i.warbycdn.com/v/c/assets/prescription-services/image/M-Rx-card-2x/0/9b0750c2b5.png"
                  className={CLASSES.imgChartMobile}
                />
              </div>
              <div className={CLASSES.body}>
                We will guide you through some quick tests to figure out how you’re seeing.{" "}
                <strong className={CLASSES.bold}>Important!</strong> Please bring in your current
                eyeglasses or eyeglasses prescription. (Totally cool if it’s expired.) The doctor
                who will review your tests needs this info to assess your refractive error, which
                helps determine your prescription.
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className={CLASSES.section}>
        <div className={CLASSES.gridRightText}>
          <div className={CLASSES.row}>
            <div className={CLASSES.col}>
              <span className={CLASSES.eyebrow} children="Final but most important step" />
              <h1 className={CLASSES.title} children="Our doctor will review your results" />
              <div className={CLASSES.imageCard}>
                <img src="https://i.warbycdn.com/v/c/assets/prescription-services/image/rx-card/0/61e4fe60fa.png" />
              </div>
              <div className={CLASSES.body}>
                An eye doctor will either write you an updated eyeglasses prescription that you can
                use anywhere or recommend that you get a comprehensive eye exam. (You will not be
                charged for using Prescription Check if you do not receive a prescription.) This
                isn’t cause for concern; it might be because you had a large change in your
                prescription, or that the doctor determined your vision history is best evaluated
                in-person. Either way, we will typically get back to you within two days.
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};
