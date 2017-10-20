const { µ, ƒ } = require("components/utilities/classNames");

module.exports = BLOCK_CLASS => ({
  cssModifierFramesGrid: µ`
    u-mw1440 u-mla u-mra u-tac
    u-pl24 u-pr24 u-pr48--900 u-pl48--900 u-pt12 u-pt0--600
    u-mb0 u-mb24--600 u-mb36--900
  `,
  dots: `u-mb12 u-mt18`,

  dot: active => µ`
    u-reset--button
    ${BLOCK_CLASS}__dot
    ${ƒ(active)("-active")}
  `,

  slider: µ`
    ${BLOCK_CLASS}__slider
    u-mla u-mra u-mw1440
    u-mb36--900 u-pr
    u-pl36--600 u-pr36--600
  `,

  container: `u-mb48 u-mb60--600 u-mb84--900`,

  slides: µ`
    u-df--600
    u-ai--c
    u-wsnw
    u-flexd--rr`,

  caption: µ`
    u-db
    u-ma u-mt12
    u-w11c u-lh28
    u-ffss u-fs14
    u-wsn
  `,

  block: µ`
    ${BLOCK_CLASS}
    u-tac u-mla u-mra
    u-pb48 u-pb72--1200
    u-mw1440`,

  FOOTER: {
    wrapper: µ`
      ${BLOCK_CLASS}__footer-wrapper
      u-color--black
      u-pb36 u-pb60--600 u-pt60--600
    `,
    image: `u-w12c`,
    imageWrapper: µ`
      u-w12c u-w5c--600 u-dib
      u-vam--600
    `,
    copyWrapper: µ`
      u-w12c u-w6c--600 u-w4c--900 u-dib
      u-vam--600 u-tal--600
      u-pl30--600 u-pr60--900 u-pl48--900
    `,
    title: µ`
      ${BLOCK_CLASS}__title
      u-fs18 u-fs24--900
      u-fwb u-pt24 u-pt0--600
      u-mb24 u-mt0--600
    `,
    body: `u-lh26 u-w10c u-w12c--600 u-mla u-mra`,
  },
  PRODUCT_HIGHLIGHT: {
    block: `u-mw1440 u-pr u-mb60--600 u-mb72--900 u-oh`,
    featureList: µ`
      ${BLOCK_CLASS}__product-highlight-feature-list 
      u-pa u-t0 u-l0 u-tac 
      u-tal--600 u-center-x u-center-y--600
    `,
    transitionWrapper: `${BLOCK_CLASS}__product-highlight-transition-wrapper`,
    feature: µ`
      ${BLOCK_CLASS}__product-highlight-feature 
      u-mb24 u-mb48--900 u-fs18 u-fs24--900
    `,
    featureHighlight: µ`
      ${BLOCK_CLASS}__product-highlight-feature 
      u-mb24 u-mb48--900 u-fs18 u-fs24--900 -bold
    `,
    featureWrapper: `
      ${BLOCK_CLASS}__product-highlight-feature-wrapper
    `,
    image: `u-w100p`,
    imageWrapper: `u-pa u-t0 u-l0 u-w100p`,
    mobileTitle: µ`
      ${BLOCK_CLASS}__product-highlight-mobile-title
      ${BLOCK_CLASS}__title
      u-dn--600
      u-pa u-t0 u-l0 u-center-x
      u-fwb u-fs18 u-color--black
      u-w12c u-pt48
    `,
    title: µ`
      ${BLOCK_CLASS}__product-highlight-title 
      ${BLOCK_CLASS}__title
      u-fwb u-color--black 
      u-dn u-db--600 u-fs18 u-fs24--900
      u-mb36 u-mb60--900
    `,
    feature: isHighlight => µ`
      ${BLOCK_CLASS}__product-highlight-feature 
      u-mb24 u-mb48--900 u-fs18 u-fs24--900
      ${ƒ(isHighlight)("-bold")}
  `,
  },
  HERO: {
    block: `u-mb36 u-mb72--600`,
    image: ` u-w12c`,
    imageWrapper: `u-pr`,
    copyWrapper: µ`
      u-tac u-w9c u-mla u-mra 
      u-color--black u-fs16
      u-lh26 u-pt36--600 u-pt60--900
    `,
    copyTop: `u-mb24 u-w10c--900 u-mla u-mra`,
    copyBottom: `u-mb24`,
    divider: µ`
      ${BLOCK_CLASS}__hero-divider
      u-mla u-mra
      u-mb24
    `,
    pricing: `u-mb48 u-mb60--600`,
    logoWrapper: µ`
      u-w8c u-w2c--600
      u-mla u-mra
      u-pt24 u-pb24
      u-pa--600 u-center--600
    `,
  },
  SLIDE: {
    picture: `u-db u-w100p`,
    image: `u-db u-w100p`,
    wrapper: µ`
      u-w100vw u-w6c--600 
      u-dib u-pl8--600 u-pr8--600
    `,
    link: `${BLOCK_CLASS}__link u-color--black u-fws`,
    linkWrapper: `u-mt12 u-mb18`,
    frame: µ`
      u-fwb u-ffs u-fs24 
      u-fs18--600 u-fs24--900 
      u-color--black
    `,
    color: µ`
      u-fsi u-ffs u-fs24 
      u-fs18--600 u-fs24--900 
      u-color--black
    `,
    secondary: count => µ`
      u-w100vw
      u-dib
      u-db--600 u-ma u-mb12--600}
      ${ƒ(count > 1)("u-w4c--600", "u-w12c--600")}`,
  },
  FRAMES: {
    cssModifierFrameBlock: µ`
      u-mr12--600 u-ml12--600
      u-mr48--1200 u-ml48--1200
      u-dib u-w100p u-w5c--600 u-mb72 u-mb48--600
    `,
    cssModifierImageWrapper: `${BLOCK_CLASS}__frame-css-modifier-image-wrapper`,
    cssModifierFrameName: `u-fs24 u-fws u-color--black u-ffs`,
    cssModifierShopLink: `${BLOCK_CLASS}__link u-color--black u-fws`,
  },
});
