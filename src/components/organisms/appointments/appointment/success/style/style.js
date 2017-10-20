const { µ, ƒ } = require("components/utilities/classNames");

module.exports = BLOCK_CLASS => ({
  col: `
    ${BLOCK_CLASS}__col
    u-grid__col u-df u-flexd--c u-flexd--r--900 u-jc--sb u-ai--c u-ma
    u-w10c--600 u-m0a
  `,
  content: `
    u-tac u-tal--900 u-w5c--900
  `,
  header: `u-fs24 u-fs30--900 u-mb6 u-fws u-ffs`,
  description: `u-fs16 u-lh26 u-fs18--900 u-lh28--900 u-color--dark-gray-alt-3 u-mt0 u-mb24`,
  linkContainer: `${BLOCK_CLASS}__link-container u-df u-jc--sa u-jc--fs--900 u-ma`,
  shopLink: `
    ${BLOCK_CLASS}__shop-link
    u-button u-button-reset -button-blue u-fs16 u-fws u-ffss u-tac
    u-mr12--900
  `
});
