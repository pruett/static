[
  _
  React

  Header
  Footer
  ModalContainer
  PromoBanner
  SmartBanner
  WelcomeBackCart
  WelcomeBackHto
  Banner
  UnsupportedBrowserNotice
  Search
  WebSiteSchema
  WebPageSchema

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/header/header'
  require 'components/organisms/footer/v2/footer/footer'
  require 'components/organisms/modals/modal_container/modal_container'
  require 'components/molecules/promo_banner/promo_banner'
  require 'components/molecules/smart_banner/smart_banner'
  require 'components/molecules/welcome_back_cart/welcome_back_cart'
  require 'components/molecules/welcome_back_hto/welcome_back_hto'
  require 'components/atoms/banner/banner'
  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'
  require 'components/organisms/products/search/search'
  require 'components/atoms/structured_data/website/website'
  require 'components/atoms/structured_data/webpage/webpage'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    componentWillMount: ->
      # This will be called directly before dispatcher_mixin,
      # ensuring up-to-date information on layout and whether
      # the navigation is open or closed.
      @commandDispatcher('layout', 'initNavigation') if window?
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
  ]

  propTypes:
    appState: React.PropTypes.object
    hideFooterEmailCapture: React.PropTypes.bool
    isAlt: React.PropTypes.bool
    showFooter: React.PropTypes.bool
    showHeader: React.PropTypes.bool

  getDefaultProps: ->
    appState: {}
    cssModifier: ''
    hideFooterEmailCapture: false
    isAlt: false
    isOverlap: false
    showFooter: true
    showHeader: true

  getStaticClasses: ->
    block:
      'u-template'
    main: "
      u-template__main
      -overlay-dark
      #{@props.cssModifier}"
    content:
      'u-template__content'
    header: '
      u-template__header
      u-flex--none'
    overlay:
      'u-template__overlay'

  classesWillUpdate: ->
    layout = @getStore('layout')

    main:
      'u-color-bg--light-gray-alt-2': @props.isAlt
      '-takeover': layout.takeover
      '-overlay': layout.isOverlayShowing
    content:
      '-visible-before-mount': _.get(@props, 'appState.location.visibleBeforeMount')
    header:
      '-hidden': layout.showHeader is false

  receiveStoreChanges: -> [
    'layout'
    'session'
    'emailCapture'
    'navigation'
    'personalization'
  ]

  render: ->
    classes = @getClasses()

    session = @getStore('session')
    navigation = @getStore('navigation')
    layout = @getStore('layout')
    emailCapture = @getStore 'emailCapture'

    isMobileAppRequest = @modifier('isMobileAppRequest')
    showHeader = @props.showHeader and not isMobileAppRequest
    showFooter = @props.showFooter and not isMobileAppRequest

    personalization = @getStore('personalization')
    htoWbVersion = _.get personalization, 'showWelcomeBackHtoVersion'
    htoWbClose = @commandDispatcher.bind(@, 'personalization', 'hideWelcomeBackHto')
    items = _.get personalization, 'lastHtoItems', []

    if (layout.takeover or layout.isOverlayShowing) and layout.scrollbarWidth
      scrollbarOffset = {paddingRight: layout.scrollbarWidth}

    <div key='layout-default' className=classes.block>
      <UnsupportedBrowserNotice />
      <Search key='search' />

      {if @getExperimentVariant('universalBanner') is 'enabled' and not isMobileAppRequest
        <Banner />}

      {if showHeader
        [
          <WelcomeBackHto
            key='WelcomeBackHto'
            active={!!htoWbVersion}
            items=items
            name={_.get session, 'customer.first_name'}
            handleClose=htoWbClose
            version=htoWbVersion />
          <WelcomeBackCart {...session.cart}
            key='WelcomeBackCart'
            active=false />
          <SmartBanner {...navigation.smart_banner}
            key='SmartBanner' /> if _.get(navigation, 'smart_banner.enabled')
          <PromoBanner {...navigation.banner}
            key='PromoBanner' /> if _.get(navigation, 'banner.show')
          <Header {...@props} {...navigation}
            key='Header'
            layout=layout
            session=session
            cssModifier=classes.header />
        ]}

      <ModalContainer key='modal-container' />

      <main key={_.get(@props.appState, 'location.component', 'main')}
        role='main'
        className=classes.main
        style=scrollbarOffset>
        <div {...@props} className=classes.content children=@props.children />
      </main>

      {if showFooter
        <Footer {...@props} {...navigation} {...emailCapture}
          session=session />
      }

      <WebSiteSchema />
      <WebPageSchema
        url={_.get(@props.appState, 'location.href', '')}
        name={_.get(@props.appState, 'location.title', '')}
        description={_.get(@props.appState, 'location.description', '')}
        navigation={_.get(navigation, 'footer_navigation_v2.columns', [])} />
    </div>
