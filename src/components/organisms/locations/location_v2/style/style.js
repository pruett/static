const { µ, ƒ } = require("components/utilities/classNames");

module.exports = BLOCK_CLASS => ({
  Intro: {
    section: `u-pt42 u-pb42 u-pt72--900 u-pb72--900`,
    grid: `u-grid u-mw1440 u-m0a u-pr`,
    row: `u-grid__row -center`,
    col: `u-grid__col u-w10c u-w6c--900 u-l3c--900`,
    storeName: `u-m0 u-fs30 u-fs40--900 u-ffs u-fws`,
    address: µ`
      ${BLOCK_CLASS}__address
      u-mt12 u-mb12 u-mt18--900 u-mb18--900 u-fs16 u-fs18--900 u-fws u-ffss
    `,
    phoneNumber: `u-fs16 u-fs18--900 u-mb24 u-mb36--900`,
    locationDescription: `u-color--dark-gray-alt-3 u-fs16 u-lh26 u-fs20--900 u-lh30--900 u-mb24 u-mb36--900`,
    hoursContainer: `u-df u-jc--sa`,
    hoursBlock: `${BLOCK_CLASS}__hours-block`,
    upperTitle: `u-ttu u-color--dark-gray-alt-2 u-fs12 u-ls1_5 u-fws`,
    hours: `u-color--dark-gray-alt-3 u-fs16 u-fs18--900`,
    hoursNote: `u-fs16 u-lh26 u-fs18--900 u-lh28--900 u-color--dark-gray-alt-3`
  },

  Appointment: {
    section: `u-oh u-color-bg--light-gray-alt-5 u-pt48 u-pb48 u-pt84--900 u-pb84--900 u-pr`,
    grid: `u-grid u-mw1440 u-m0a u-pr`,
    row: `u-grid__row -center`,
    col: `u-grid__col u-w10c u-w6c--900 u-l3c--900`,
    welcome: inProgress => ƒ(inProgress)("u-dn"),
    welcomeHeader: `u-fs24 u-fws u-ffs u-fs30--900 u-mt0`,
    welcomeDescription: `u-fs16 u-lh26 u-color--dark-gray-alt-3 u-fs18--900 u-lh28--900 u-mb36`,
    picker: inProgress => µ`
      ${BLOCK_CLASS}__appointment-container
      u-df--900 u-ai--c
      ${ƒ(inProgress)("", "u-dn u-dn--900")}
    `,
    footerActionContainer: `${BLOCK_CLASS}__appointment-footer u-mt48 u-pt24 u-pt36--900 u-btss u-btw1 u-bc--light-gray u-pr u-b0 u-center-x u-w100p`,
    footerDateTime: `u-tac u-fs20 u-fws u-ffs u-mt0 u-mb6 u-mb12--900`,
    footerAction: `u-fs16 u-db u-tac u-ffss u-tac u-fws`
  },

  Services: {
    section: `u-pt48 u-pb48 u-pt84--900 u-pb84--900`,
    grid: `u-grid u-mw1440 u-m0a`,
    row: `u-grid__row -center`,
    col: `u-grid__col u-w10c`,
    heading: `u-mt0 u-mb24 u-fs24 u-fs30--900 u-fws u-ffs`,
    container: isThird => µ`
      ${ƒ(isThird)("", "u-flexw--w")}
      u-df u-flexd--c u-flexd--r--900 u-jc--c u-ai--fs
    `,
    callout: isThird => µ`
      ${BLOCK_CLASS}__services-callout
      u-mt24
      ${ƒ(isThird)("-thirds", "-non-thirds")}
    `,
    image: `${BLOCK_CLASS}__services-image u-mb6 u-mb30--900`,
    name: `u-fs16 u-fs20--900 u-ffss u-fws u-m0`,
    description: `u-fs16 u-lh26 u-fs18--900 u-lh28--900 u-mt8 u-mb0 u-color--dark-gray-alt-3`
  },

  GTK: {
    section: `u-pt48 u-pb48 u-pt84--900 u-pb48--900 u-btw1 u-btss u-bc--subtle-gray`,
    grid: `u-grid u-mw1440 u-m0a`,
    row: `u-grid__row u-tac u-tal--900`,
    col: `u-grid__col u-w10c u-w12c--600`,
    contentContainer: `u-df u-ai--fs u-w12c u-w9c--600 u-w10c--900 u-m0a`,
    content: hasImg => µ`
      u-tac
      ${ƒ(hasImg)("u-tal--900 u-pl84--900")}
    `,
    heading: `u-tac u-mt0 u-mb24 u-mb48--900 u-fs24 u-fs30--900 u-fws u-ffs`,
    image: µ`
      ${BLOCK_CLASS}__gtk-img
      u-dn u-db--900 u-w6c--900
    `,
    subHeading: `u-fs16 u-fws u-mb8 u-fs20--900`,
    paragraph: `u-fs16 u-lh26 u-mb12 u-color--dark-gray-alt-3 u-fs18--900 u-lh28--900 u-mb24--900`,
    ul: `u-pr`,
    li: `${BLOCK_CLASS}__gtk-li u-mb12 u-fs16 u-color--dark-gray-alt-3 u-pl20 u-tal u-fs18--900`
  },

  Nearby: {
    section: `u-color-bg--light-gray-alt-5 u-pt48 u-pb48 u-pt84--900 u-pb48--900 u-btw1 u-btss u-bc--subtle-gray`,
    grid: `u-grid u-mw1440 u-m0a`,
    row: `u-grid__row`,
    col: `u-grid__col u-w12c`,
    locationContainer: `u-df u-flexd--c u-flexd--r--900 u-reset--list u-jc--c u-ai--c`,
    heading: `u-tac u-mt0 u-mb36 u-mb60--900 u-fs24 u-fs30--900 u-fws u-ffs`,
    card: µ`
      ${BLOCK_CLASS}__nearby-card
      u-color-bg--white u-br4
      u-br4
    `,
    cardContentContainer: `u-df u-ai--c u-br4 u-oh`,
    cardImage: µ`
      ${BLOCK_CLASS}__nearby-card-img
      u-w3c
    `,
    cardAbout: µ`
      ${BLOCK_CLASS}__nearby-card-about
      u-pl24 u-pr10
    `,
    locationName: `u-fs16 u-fs20--900 u-fws u-ffss u-m0`,
    hours: `u-fs16 u-fs18--900 u-color--dark-gray-alt-3 u-mt6`,
    eyeExamAvailability: `u-color--dark-gray-alt-2 u-ttu u-ls2_5 u-fs10 u-fws u-mb0`,
    linkAll: `${BLOCK_CLASS}__link-all u-fs16 u-fs18--900 u-fws u-ffss u-color--dark-gray u-tac u-dib u-mt24`
  }
});
