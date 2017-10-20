const React = require("react/addons");
const Step = require("./step/step");
const Choice = require("./choice/choice");
const LensDetailEnhancer = require("components/molecules/products/lens_details_container/lens_details_container");
const X = require("components/quanta/icons/thin_x/thin_x");
const { makeStartCase } = require("hedeia/common/utils/string_formatting");

const {
  VARIANTS,
  CHOICES,
  isProgRx,
  isPhoto,
} = require("components/utilities/products/variants");

require("./atc.scss");

const BLOCK_CLASS = 'c-atc';

const CLASSES = {
  applePay:
    `${BLOCK_CLASS}__apple-pay c-atc__submit--apple-pay u-pr u-reset u-button -button-large -button-full u-color-bg--black -v3 u-vam u-fs16 u-fws`,
  applePayImg: "u-mtn1 u-mw100p u-pa u-center",
  buttons: "u-mb8",
  close: "u-reset--button u-pa u-r0 u-center-y",
  col: `${BLOCK_CLASS}__copy u-grid__col u-w12c u-w8c--600 u-w6c--900 u-w5c--1200 u-tac`,
  container: "u-w100p u-w100p u-h100p u-hauto--900 u-pa--900 u-center-y--900",
  frameColor:
    "u-reset u-fs16 u-fs18--900 u-fsi u-ffs u-dib u-color--dark-gray-alt-2",
  frameName: "u-reset u-fs24 u-fs36--900 u-fws u-ffs u-dib u-mr12 u-tal",
  grid: "u-grid -maxed u-ma u-pt24 u-pb24",
  header: "u-pb18 u-pt18 u-pb0--900 u-grid -maxed u-ma",
  headerCol:
    "u-grid__col u-w12c u-w8c--600 u-w6c--900 u-w5c--1200 u-l2c--600 u-l6c--900 u-l7c--1200 u-tal",
  headerRow: "u-grid__row u-tac u-tar--900",
  headerWrapper: "u-pr",
  learn:
    "u-reset--button u-color--blue u-ma u-color--blue u-db u-tac u-mb24 u-mb48--900 u-fs16 u-fws",
  main:
    `${BLOCK_CLASS} u-pa u-w100p u-t0 u-b0 u-l0 u-color-bg--white u-btw1 u-btss u-bc--light-gray u-bw0--900 u-mw1440 u-ma u-r0`,
  row: "u-grid__row",
  section:
    "u-color-bg--light-gray-alt-2 u-color-bg--white--900 u-tac u-tar--900 u-h100p u-pb12",
  steps: "u-reset--list u-mb24 u-tal c-cta__list u-wsnw",
  submit: "u-fs16 u-fws u-button -button-blue -button-large -button-full -v2",
  glasses: " u-pr12",
  image: "u-dn u-db--900 u-pa u-t50p u-l0 u-w6c",
  decimal: `${BLOCK_CLASS}__decimal`
};

function Glasses({ currentIndex, label, isPhoto, isProgRx, diagramImages }) {
  const currentLabel = currentIndex === 0
    ? "prescription_offerings"
    : "lens_offerings";

  const showUpgrade =
    (isPhoto && currentIndex === 1) || (isProgRx && currentIndex === 0);

  const cssImageOverlay = currentIndex === 1
    ? `${CLASSES.image} c-atc__fade-in ${showUpgrade ? "-start" : ""}`
    : showUpgrade ? CLASSES.image : "u-dn";

  const style = {
    // Flip frames for Photochromics.
    transform: currentIndex === 0
      ? "translateY(-50%)"
      : "translateY(-50%) scaleX(-1)",
  };

  return (
    <div
      className={`${CLASSES.glasses} ${currentLabel !== label ? "u-dn" : ""}`}
      key={currentLabel}
    >
      <img
        src={diagramImages[0][2].image}
        style={style}
        className={CLASSES.image}
      />
      <img
        src={diagramImages[1][2].image}
        style={style}
        className={cssImageOverlay}
      />
    </div>
  );
}

const NewGlasses = LensDetailEnhancer(Glasses);

Glasses.propTypes = {
  currentIndex: React.PropTypes.number,
  isPhoto: React.PropTypes.bool,
  isProgRx: React.PropTypes.bool,
  diagramImages: React.PropTypes.array,
  label: React.PropTypes.string,
};

class ATC extends React.Component {
  handleClickChoice(variant) {
    this.props.handleClickChoice(variant);
  }

  get isProgRx() {
    return isProgRx(this.props.selectedVariantType);
  }

  get isPhoto() {
    return isPhoto(this.props.selectedVariantType);
  }

  get product() {
    return this.props.colors[this.props.activeColorIndex];
  }

  get variants() {
    return this.product.variants;
  }

  get variant() {
    return this.variants[this.props.selectedVariantType];
  }

  get productPrice() {
    return this.variants[this.props.selectedVariantType].price_cents / 100;
  }

  get upgradePriceCents() {
    // Calculate price of photochromic upgrade.
    const isProgRxVariant = isProgRx(this.props.selectedVariantType);
    const baseKey = VARIANTS[isProgRxVariant ? "progRx" : "rx"];
    const upgradeKey = VARIANTS[isProgRxVariant ? "progRxPhoto" : "rxPhoto"];

    const base = this.variants[baseKey];
    const upgrade = this.variants[upgradeKey];

    return !(base || upgrade) ? 0 : upgrade.price_cents - base.price_cents;
  }

  renderSteps() {
    return (
      <ol className={CLASSES.steps}>
        {["Select prescription type", "Select lenses"].map((text, index) => {
          let copy = text;
          if (this.props.stepHasChanged && index !== this.props.stepIndex) {
            // Override other step if choices have been made.
            copy = index === 0
              ? this.isProgRx ? "Progressive" : "Single-vision"
              : this.isPhoto ? "Light-responsive" : "Clear (standard)"
          }

          return (
            <Step
              key={index}
              onClick={() => this.props.manageChangeStepIndex(index)}
              isActive={this.props.stepIndex === index}
            >
               <span className={CLASSES.decimal}>{`${index + 1}. `}</span>
               <span>{`${copy}`}</span>
            </Step>
          );
        })}

      </ol>
    );
  }

  renderChoices() {
    return (
      <div
        className={CLASSES.buttons}
        children={
          this.props.stepIndex === 0
            ? [
                <Choice
                  isActive={!this.isProgRx}
                  onClick={() => this.handleClickChoice(CHOICES.rx)}
                  name="Single-vision"
                  description="For one field of vision (near or distance) or readers"
                  key={CHOICES.rx}
                  price={`$${this.variants["rx"].price_cents / 100}`}
                />,
                <Choice
                  isActive={this.isProgRx}
                  onClick={() => this.handleClickChoice(CHOICES.progRx)}
                  name="Progressive"
                  description="Covers reading, distance, and in between"
                  key={CHOICES.progRx}
                  price={`$${this.variants["prog_rx"].price_cents / 100}`}
                />,
              ]
            : [
                <Choice
                  isActive={!this.isPhoto}
                  onClick={() => this.handleClickChoice(CHOICES.clear)}
                  key={CHOICES.clear}
                  name="Clear (standard)"
                  description="Made from thin, light, impact-resistant polycarbonate"
                  price="Included"
                />,
                <Choice
                  isActive={this.isPhoto}
                  onClick={() => this.handleClickChoice(CHOICES.photo)}
                  key={CHOICES.photo}
                  name="Light-responsive"
                  description="Lenses that change from clear to dark grey in the sun (rain or shine)"
                  price={`+ $${this.upgradePriceCents / 100}`}
                />,
              ]
        }
      />
    );
  }

  renderFooter() {
    const { isApplePayCapable } = this.props.applePay;
    return (
      <footer>
        <button
          className={CLASSES.learn}
          onClick={() => this.props.scrollToLearning(this.props.stepIndex)}
          children={
            this.props.stepIndex === 0
              ? "Learn more about prescription options"
              : "Learn more about our lenses"
          }
        />
        <button
          onClick={() => {
            this.props.stepIndex === 0
              ? this.props.manageClickSelectLenses()
              : this.props.manageAddItem({
                  product_id: this.product.id,
                  variant_id: this.variant.variant_id,
                  hto_in_stock: _.get(this.product, 'variants.hto.in_stock', false),
                });
          }}
          className={
            this.props.stepIndex === 0 || !isApplePayCapable
              ? CLASSES.submit
              : `c-atc__submit--apple-pay ${CLASSES.submit}`
          }
          children={
            this.props.stepIndex === 0
              ? "Submit and select lenses"
              : `Add to cart: $${this.productPrice}`
          }
        />
        {isApplePayCapable &&
          this.props.stepIndex === 1 &&
          <button
            onClick={() =>
              this.props.manageApplePay({
                product_id: this.product.id,
                variant: this.variant,
              })}
            className={CLASSES.applePay}
          >
            <img
              height="40"
              className={CLASSES.applePayImg}
              src="https://i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-black-mobile/2/30420a3aad.jpg"
            />
          </button>}
      </footer>
    );
  }

  render() {
    return (
      <main className={CLASSES.main}>
        <div className={CLASSES.container}>
          <header className={CLASSES.header}>
            <div className={CLASSES.headerRow}>
              <div className={CLASSES.headerCol}>
                <div className={CLASSES.headerWrapper}>
                  <h1 className={CLASSES.frameName}>
                    {this.product.display_name}
                  </h1>
                  <h2 className={CLASSES.frameColor}>
                    {makeStartCase(this.product.color)}
                  </h2>
                  <button
                    type="button"
                    className={CLASSES.close}
                    onClick={this.props.toggleAtc}
                  >
                    <X />
                  </button>
                </div>
              </div>
            </div>
          </header>
          <NewGlasses
            currentIndex={this.props.stepIndex}
            isPhoto={this.isPhoto}
            isProgRx={this.isProgRx}
            displayShapes={this.product.display_shape}
            gender={this.product.gender}
          />
          <section className={CLASSES.section}>
            <div className={CLASSES.grid}>
              <div className={CLASSES.row}>
                <div className={CLASSES.col}>
                  {this.renderSteps()}
                  {this.renderChoices()}
                  {this.renderFooter()}
                </div>
              </div>
            </div>
          </section>
        </div>
      </main>
    );
  }
}

ATC.defaultProps = {
  activeColorIndex: 0,
  applePay: {
    isApplePayCapable: false,
  },
  colors: [],
  manageAddItem: () => {},
  manageApplePay: () => {},
  handleClickChoice: () => {},
  manageChangeStepIndex: () => {},
  manageClickSelectLenses: () => {},
  selectedVariantType: VARIANTS.rx,
  stepIndex: 0,
  stepHasChanged: false,
  toggleAtc: () => {},
};

ATC.propTypes = {
  activeColorIndex: React.PropTypes.number,
  applePay: React.PropTypes.object,
  colors: React.PropTypes.array,
  manageAddItem: React.PropTypes.func,
  manageApplePay: React.PropTypes.func,
  manageChangeSelectedVariantType: React.PropTypes.func,
  manageChangeStepIndex: React.PropTypes.func,
  manageClickSelectLenses: React.PropTypes.func,
  selectedVariantType: React.PropTypes.string,
  stepIndex: React.PropTypes.number,
  stepHasChanged: React.PropTypes.bool,
  toggleAtc: React.PropTypes.func,
};

module.exports = ATC;
