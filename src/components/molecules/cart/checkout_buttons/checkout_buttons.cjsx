[
  _
  React

  CTA
  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './checkout_buttons.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-buttons'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.image
  ]

  propTypes:
    applePay: React.PropTypes.object
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    applePay: {}
    cssModifier: ''
    cssUtility: ''
    ctaCopy: 'Checkout'
    disabled: false

  handleApplePay: (evt) ->
    @trackInteraction 'cart-click-applePay', evt
    @commandDispatcher 'applePay', 'checkout', 'cart'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    cta: '
      u-button -button-blue -button-large -v2
      u-fws u-fs16
    '
    applePay: "
      #{@BLOCK_CLASS}__apple-pay
      u-reset
      u-color-bg--black
      u-fs16 u-fwb
      u-ml12
      u-w6c u-dib
      u-pr u-vam u-oh
      u-mw100p
    "
    error: "
      #{@BLOCK_CLASS}__error
      u-reset
      u-color--yellow
      u-fs14 u-fs16--600 u-mt6
      u-tac u-fws
    "
    picture: "
      #{@BLOCK_CLASS}__picture
      u-pa u-t50p u-l50p
      u-ttn50n50
    "
    img: "
      u-db u-ma
    "

  classesWillUpdate: ->
    isApplePayCapable = _.get(@props, 'applePay.isApplePayCapable', false) and not @props.disabled

    cta:
      "#{@BLOCK_CLASS}__cta": not isApplePayCapable
      "#{@BLOCK_CLASS}__cta--apple-pay": isApplePayCapable
      'u-pen -disabled': @props.disabled

  getPictureAttrs: (klass) ->
    sources: [
      url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-black-tablet/2/faec072abe.jpg'
      quality: 90
      widths: [ 180, 270, 360 ]
      sizes: '180px'
      mediaQuery: '(min-width: 600px)'
    ,
      url: '//i.warbycdn.com/v/c/assets/apple-pay/image/apple-pay-black-mobile/2/30420a3aad.jpg'
      quality: 90
      widths: [ 140, 210, 280 ]
      sizes: '140px'
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'ApplePay'
      className: klass

  mapError: (classes, error, i) ->
    <p key=i className=classes.error children=error />

  render: ->
    classes = @getClasses()
    isApplePayCapable = _.get(@props, 'applePay.isApplePayCapable', false) and not @props.disabled

    <div className=classes.block>
      {if isApplePayCapable
        <button type='button'
          onClick=@handleApplePay
          className=classes.applePay>
          <Picture
            cssModifier=classes.picture
            children={@getPictureChildren(@getPictureAttrs(classes.img))}/>
        </button>}

      <CTA
        analyticsSlug='cart-click-checkout'
        children=@props.ctaCopy
        cssModifier=classes.cta
        href='/checkout'
        tagName='a'
        variation='minimal' />
      {_.map _.get(@props, 'applePay.errors'), @mapError.bind(@, classes)}
    </div>
