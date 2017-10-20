const { µ, ƒ } = require("components/utilities/classNames");

module.exports = BLOCK_CLASS => ({
  stage: µ`
    ${BLOCK_CLASS}__stage
    u-pb5x4 u-pb5x2--900
    u-h0 u-oh u-pr
  `,

  slidesContainer: µ`
    ${BLOCK_CLASS}__slides-container
    u-pa u-h100p u-df
  `,

  fullSlide: µ`
    ${BLOCK_CLASS}__full-slide
  `,

  halfSlide: µ`
    ${BLOCK_CLASS}__half-slide
  `,

  slide: `u-w100p u-h100p`,

  arrowContainer: µ`
    u-dn u-df--900 u-jc--sb u-ai--c
    u-pa u-t0 u-b0 u-r0 u-l0 u-center-y
    u-pl48 u-pr48
  `,

  indicatorContainer: hasSlides => µ`
    ${ƒ(hasSlides)("u-df u-jc--c", "u-dn")}
    u-reset--list u-mb30 u-dn--900
    u-pa u-b0 u-l0 u-r0 u-center-x
  `,

  indicator: isCurrent => µ`
    ${BLOCK_CLASS}__indicator
    ${ƒ(isCurrent)("-active", "")}
  `,

  button: `u-pr u-button-reset ${BLOCK_CLASS}__button`,

  shadow: µ`
    ${BLOCK_CLASS}__shadow
    u-db u-dn--900 u-pa u-pl24 u-pl36--600 u-pr24 u-pr36--600 u-pt60 u-pb24 u-w100p
  `,

  arrow: `u-pr ${BLOCK_CLASS}__arrow`
});
