[
  _
  React

  ProgressIndicator
  LogoImage
  Notification
  BackLink
  Footer

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/progress_indicator/progress_indicator'
  require 'components/atoms/images/logo/logo'
  require 'components/atoms/notification/notification'
  require 'components/atoms/back_link/back_link'
  require 'components/atoms/checkout/footer/footer'

  require 'components/mixins/mixins'

  require './container.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  BLOCK_CLASS: 'c-checkout-container'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    appState: React.PropTypes.object
    checkout: React.PropTypes.object
    cssModifier: React.PropTypes.string
    checkoutNotification: React.PropTypes.object
    showLogo: React.PropTypes.bool
    showNotification: React.PropTypes.bool
    showProgress: React.PropTypes.bool
    checkoutSteps: React.PropTypes.array

  getDefaultProps: ->
    appState: {}
    cssModifier: ''
    checkoutNotification: {}
    showLogo: true
    showNotification: false
    showProgress: true
    checkoutSteps: []

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    transition:
      "#{@BLOCK_CLASS}__notification"
    logoModifier: "
      #{@BLOCK_CLASS}__logo
      u-db u-mla u-mra
      u-mt18 u-mb18
    "
    logoUtility:
      'u-icon'
    content: [
      'u-template__content'
      "#{@BLOCK_CLASS}__content"
      "#{@props.cssModifier}"
    ]
    back: [
      "#{@BLOCK_CLASS}__back"
      'u-reset u-fs12 u-fws'
    ]
    backLink :
      "#{@BLOCK_CLASS}__back-link"
    headerContainer:
      'u-mln18 u-mrn18 u-mb24
       u-bbss u-bw1 u-bc--light-gray'

  classesWillUpdate: ->
    content:
      '-visible-before-mount': _.get(@props, 'appState.location.visibleBeforeMount')

  manageClickClose: ->
    @commandDispatcher 'checkout', 'clearNotification'

  render: ->
    classes = @getClasses()

    <div className=classes.block>

      {if @props.showNotification
        <ReactCSSTransitionGroup transitionName=classes.transition>

          {if @props.checkoutNotification.text
            <Notification handleClickClose=@manageClickClose key='notification'>
              <span children=@props.checkoutNotification.text />

              {if @props.checkoutNotification.route
                <a href=@props.checkoutNotification.route
                  className=classes.back
                  children='Back to options' />}
            </Notification>}

        </ReactCSSTransitionGroup>}

      {if @props.showLogo
        <div className=classes.headerContainer>
          <a href='/' onClick={@trackInteraction.bind(@, 'checkout-click-headerLogo')}>
            <LogoImage {...@props}
              cssModifier=classes.logoModifier
              cssUtility=classes.logoUtility />
          </a>
        </div>}

      {if @props.showProgress
        indicatedSteps = _.filter @props.checkoutSteps, (step) -> step.indicated
        <ProgressIndicator steps=indicatedSteps />}

      <div {...@props} className=classes.content>
        {unless @props.showLogo
          <BackLink {...@props}
            cssModifier=classes.backLink
            version=2 />}

        {@props.children}
      </div>

      {if @props.showProgress or @props.forceFooter
        <Footer border=false />}

    </div>
