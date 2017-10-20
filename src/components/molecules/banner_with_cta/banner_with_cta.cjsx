[
  _
  React

  CTA
  UploadCTA

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/molecules/upload_cta/upload_cta'

  require 'components/mixins/mixins'

  require './banner_with_cta.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-banner-with-cta'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    order_id: React.PropTypes.string
    headline: React.PropTypes.string
    message: React.PropTypes.string
    cta: React.PropTypes.string
    action: React.PropTypes.string
    title: React.PropTypes.string
    suppressUpload: React.PropTypes.bool
    showEyeExamLink: React.PropTypes.bool

  getDefaultProps: ->
    headline: ''
    message: ''
    cta: ''
    action: ''
    title: 'banner_with_cta'
    suppressUpload: false
    showEyeExamLink: false

  getStaticClasses: ->
    block: @BLOCK_CLASS
    content:
      "#{@BLOCK_CLASS}__content
      u-tac u-tal--900"
    headline:
      "#{@BLOCK_CLASS}__headline
       u-fws"
    message:
      "#{@BLOCK_CLASS}__description
       u-ffss u-fs14 u-m0"
    cta:
      "#{@BLOCK_CLASS}__cta
       u-button u-fs14 u-db
       u-fws u-center-y--900"
    ctaWrapper:
      'u-w12c u-w5c--900 u-dib--900'
    copyWrapper:
      'u-w12c u-w7c--900 u-dib--900'

  classesWillUpdate: ->
    cta:
      '-button-blue': @props.action.toLowerCase() is 'upload'
      '-button-clear': @props.action.toLowerCase() isnt 'upload'

  getActionRoute: (action) ->
    switch action
      when 'email' then 'mailto:help@warbyparker.com'
      when 'phone' then 'tel:888.492.7297'
      when 'chat' then '/chat'
      when 'pd' then '/pd/instructions'
      when 'upload' then "/account/orders/#{@props.order_id}/prescription"
      else ''

  handleClick: (action, evt) ->
    return unless _.isString action
    if action is 'chat'
      evt.preventDefault()
      @commandDispatcher 'livechat', 'openChat'

  render: ->
    @classes = @getClasses()
    action = @props.action.toLowerCase()

    <div className=@classes.block>
      <div className=@classes.content>
        <div className=@classes.copyWrapper>
          <div className=@classes.headline
            children=@props.headline />
          <p className=@classes.message
            children=@props.message />
        </div>
        <div className=@classes.ctaWrapper>
          {if action is 'upload' and window?.FormData? and not @props.suppressUpload
            <UploadCTA
              orderId=@props.order_id
              variation='minimal'
              cssModifier=@classes.cta
              title='Upload'
              showEyeExamLink=@props.showEyeExamLink
              children=@props.cta />
          else
            <CTA
              analyticsSlug=@props.analyticsSlug
              children=@props.cta
              href=@getActionRoute(@props.action)
              onClick={@handleClick.bind(@, action)}
              variation='minimal'
              cssModifier=@classes.cta
              title=@props.title
              trackImpressions=true
              tagName='a' />
          }
        </div>
      </div>
    </div>
