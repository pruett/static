[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './amex.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-amex'

  amexCheckoutLoginWindow: null

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''

  receiveStoreChanges: -> [
    'config'
    'scripts'
  ]

  componentDidMount: ->
    config = @getStore 'config'
    return if @getStore('scripts')['amexCheckout']
    @commandDispatcher 'scripts', 'load',
      name: 'amexCheckout'
      src: config.scripts.amex

  handleClick: (event) ->
    event.preventDefault()
    @trackInteraction event
    if @amexCheckoutLoginWindow and not @amexCheckoutLoginWindow.closed
      event.focus()
    else
      # Amex's JS introduces an `Amex` global. This popup window code is mostly
      # straight from them, except for some renamed variables.
      if Amex?
        if Amex.Utils.windowWidth() <= Amex.SDKConfig.get('mobile.width.cutoff')
          popupWidth = Amex.Utils.windowWidth()
          popupHeight = Amex.SDKConfig.get 'authentication.window.mobile.height'
        else
          popupWidth = Amex.SDKConfig.get 'authentication.window.width'
          popupHeight = Amex.SDKConfig.get 'authentication.window.height'
        leftOffset = Amex.Utils.windowWidth() - popupWidth
        leftOffset = if leftOffset < 0 then 0 else leftOffset / 2
        topOffset = Amex.Utils.windowHeight() - popupHeight
        topOffset = if topOffset < 0 then 0 else topOffset / 2

        Amex.Widget.parse document, 'buy'
        @amexCheckoutLoginWindow = window.open Amex.URLs.prepareAuthWindowUrl(),
          'PayWithAmex',
          "toolbar=no,menubar=no,location=no,resizable=yes,status=no,top=#{topOffset},\
            left=#{leftOffset},width=#{popupWidth},height=#{popupHeight}"

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssUtility
      @props.cssModifier
    ]
    buttonWrapper: "#{@BLOCK_CLASS}__button-wrapper"

  classesWillUpdate: ->
    block:
      'u-dn': not _.get(@getStore('scripts'), 'amexCheckout.loaded', false)

  render: ->
    classes = @getClasses()
    config = @getStore 'config'

    props =
      className: classes.block
      onClick: @handleClick

    if config.amex and config.environment
      props.dangerouslySetInnerHTML =
        __html: "
          <div class='#{classes.buttonWrapper} amex-express-checkout'>
          </div>
          <amex:init
            button_color='plain'
            client_id='#{config.amex.client_id}'
            disable_btn='false'
            env='#{config.amex.environment}'
            theme='desktop' />
        "

    <div {...props} />
