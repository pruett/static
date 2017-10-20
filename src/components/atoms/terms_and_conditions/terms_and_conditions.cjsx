[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-terms-and-conditions'

  COPY:
    text:
      checkoutLogin:
        "By continuing as a new customer or signing in,
        you agree to the |terms| and |privacyPolicy|."
      checkout:
        "By placing this order, you agree to the |terms| and |privacyPolicy|."
      login:
        "By creating this account, you agree to the |terms| and |privacyPolicy|."
      appointment:
        "By booking an appointment, you agree to the |terms| and |privacyPolicy|."
    links:
      terms:
        title: "Terms of Use"
        href: '/terms-of-use'
      privacyPolicy:
        title: "Privacy Policy"
        href: '/privacy-policy'

  propTypes:
    variation: React.PropTypes.oneOf ['login', 'checkout', 'checkoutLogin', 'appointment']

  getDefaultProps: ->
    variation: 'login'
    cssModifier: 'u-w9c--600 u-mt12 u-mb12'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-tac u-mla u-mra
      u-color--dark-gray-alt-1
    "
    link:
      'u-dib'

  renderLink: (classes, link) ->
    linkCopy = _.get @COPY.links, link
    linkProps =
      className: classes.link
      href: linkCopy.href
      onClick: @trackInteraction.bind @, "legal-click-#{link}"
      children: linkCopy.title
      target: '_blank'
      rel: 'noopener noreferrer'

    <a {...linkProps} />

  linkOrText: (classes, key) ->
    if _.has(@COPY.links, key) then @renderLink(classes, key) else key

  render: ->
    classes = @getClasses()
    copyText = _.get @COPY.text, @props.variation
    rawCopy = copyText.split '|'

    renderedCopy = _.map rawCopy, _.partial(@linkOrText, classes).bind(@)

    <div className=classes.block children=renderedCopy />
