[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './popover_container_apple_pay.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-popover-container-apple-pay'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    analyticsCategory: React.PropTypes.string
    handleClose: React.PropTypes.func
    isApplePayActive: React.PropTypes.bool
    applePay: React.PropTypes.object

  getDefaultProps: ->
    handleClose: ->
    analyticsCategory: 'addButtonPdp'
    applePay: {}

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pf
      u-t0
      u-r0
      u-b0
      u-l0
      u-w100p
      u-color-bg--dark-gray-95p
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-pa
      u-t50p u-l50p u-ttn50n50
      u-w1440 u-mw100p
    "
    error: '
      u-reset
      u-color--yellow
      u-fs14 u-fs16--600 u-mb6
      u-tac u-fws
    '
    cancel: "
      #{@BLOCK_CLASS}__cancel
      u-pf
      u-p18 u-p48--600
      u-t0
      u-r0
      u-mw1440
      u-tar
      u-ma
    "
    x: "
      #{@BLOCK_CLASS}__x
      u-pr
      u-button-reset
    "
    variants: "
      #{@BLOCK_CLASS}__variants
    "

  classesWillUpdate: ->
    variants:
      '-hide': @shouldHideVariants()

  handleClose: (evt) ->
    name = if @props.applePay.isApplePayCapable then 'applePayClick' else 'click'

    @trackInteraction "#{@props.analyticsCategory}-#{name}-cancel", evt
    @props.handleClose()

  shouldHideVariants: ->
    _.get(@props, 'applePay.isApplePayActive') and
      _.size(_.get(@props, 'applePay.errors', [])) is 0

  mapError: (classes, error, i) ->
    <p key=i className=classes.error children=error />

  render: ->
    classes = @getClasses()

    <div id='pdp__popover--purchase' className=classes.block role='dialog' ref='container'>
      <div className=classes.variants>
        <div className=classes.cancel key='cancel'>
          <button className=classes.x onClick=@handleClose />
        </div>

        <div key='content' className=classes.content>
          {@props.children}
          {_.map _.get(@props, 'applePay.errors'), @mapError.bind(@, classes)}
        </div>
      </div>
    </div>
