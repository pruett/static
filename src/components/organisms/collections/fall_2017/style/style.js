const trim = str => str.replace(/\s+/g, " ").trim();
const ƒ = bool => (left = "", right = "") => (bool ? left : right);
const µ = (strs, ...exps) => {
  // Trim template string literals.
  return trim(strs.reduce((acc, part, i) => acc + exps[i - 1] + part));
};

///////////////////////////////

module.exports = BLOCK_CLASS => ({
  block: µ`
    ${BLOCK_CLASS}
    u-tac u-mla u-mra
    u-pb48 u-pb0--1200
    u-w100vw u-oh`,

  grid: `u-grid -maxed u-ma u-mb36`,

  row: `u-grid__row`,

  carousel: µ`
    u-mb48
    u-fs16 u-ffss
    u-grid__col u-w12c u-w6c--600`,

  frame: `u-mr3 u-fws`,

  frameName: `u-mt18 u-mt24--900 u-fws u-fs24 u-ffs u-mb18 u-reset u-tac`,

  dots: `u-mb12`,

  dot: active => µ`
    u-reset--button
    ${BLOCK_CLASS}__dot
    ${ƒ(active)("-active")}
  `,

  slider: µ`
    ${BLOCK_CLASS}__slider
    u-mla u-mra u-mw1440
    u-mb36--600 u-pr
  `,

  container: `u-mb48 u-mb72--600 u-mb84--900`,

  slides: invert => µ`
    u-df--600
    u-ai--c
    u-wsnw
    ${ƒ(!invert)("u-flexd--rr")}`,

  caption: stacked => µ`
    u-dn u-db--900
    u-ma u-mt12
    ${ƒ(stacked)("u-w4c", "u-w8c")}
    u-ffss u-fs14
    u-lh20
    u-wsn
  `,

  HERO: {
    logo: `u-mb18`,
    copyWrapper: `u-ma u-w11c u-w6c--600 u-w7c--900 u-pt30`,
    image: `u-w100p u-db`,
    header: µ`
      u-reset
      u-color--dark-gray
      tk-utopia-std-display
      u-fwn
      u-ffss u-fs34 u-fs55--900 u-mb12`,
    body: µ`
      u-reset
      u-color--dark-gray
      u-fs16 u-ls20 u-fwn
      u-mla u-mra u-mb24
      u-ffss`,
    imageWrapper: `u-pr u-oh`,
    hr: µ`
      u-reset
      u-w4c u-w3c--600 u-w2c--900
      u-bw0 u-btw1 u-bss u-bc--light-gray
      u-ma u-mb24`,
    links: `u-ma`,
    link: index => µ`
      ${ƒ(index === 0)("u-color--blue", "u-color--dark-gray")}
      u-mr12 u-ml12
      u-ttu u-ls1_5
      u-fws u-ffss u-fs12
    `,
    wrapper: µ`
      u-pr u-mw1440
      u-mla u-mra
      u-mb36 u-mb84--600 u-mb64--1200`,
    videoOne: `${BLOCK_CLASS}__video-1`,
    videoTwo: `${BLOCK_CLASS}__video-2`
  },

  SLIDE: {
    video: `${BLOCK_CLASS}__video`,
    picture: `u-db u-w100p`,
    image: `u-db u-w100p`,
    wrapper: "u-w100vw u-w6c--600 u-dib",
    secondary: (count, stacked) => µ`
      u-w100vw
      u-dib
      ${ƒ(stacked)("u-db--600 u-ma u-mb12--600", "u-mr6--600 u-ml6--600")}
      ${ƒ(count > 1)("u-w4c--600", "u-w7c--600")}`
  }
});
