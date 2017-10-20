[
  _
  React

  LogoImage
  ModalContainer
  TempFooter
  UnsupportedBrowserNotice
  HelpFooter

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/logo/logo'
  require 'components/organisms/modals/modal_container/modal_container'
  require 'components/molecules/footers/temp_footer/temp_footer'
  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'
  require 'components/molecules/pd/footer/footer'

  require 'components/mixins/mixins'

  require './layout_minimal.scss'
]

module.exports = React.createClass
  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.context
  ]

  propTypes:
    appState: React.PropTypes.object
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    appState: {}
    cssModifier: ''
    showFooter: true
    showHelpFooter: false

  receiveStoreChanges: -> [
    'navigation'
  ]
  
  FOOTER_CONTENT_PATH: "/footer"
    
  fetchVariations: -> [
    @FOOTER_CONTENT_PATH
  ]

  getStaticClasses: ->
    block: 'u-template'
    header: 'c-header u-template__header
      u-flex--none u-pr u-w100p u-mw1440
      u-mra u-mla u-tac u-wsnw
      u-color-bg--white u-pr6 u-pl6'
    logo: 'c-header__logo u-vam--900
      u-pa u-pr--900 u-dib--900'
    main: 'u-template__main -full-page'
    footer: 'u-template__footer u-flex--none'

  render: ->
    classes = @getClasses()
    navigation = @getStore('navigation')
    footer = @getContentVariation(@FOOTER_CONTENT_PATH);

    <div className=classes.block>
      <UnsupportedBrowserNotice />

      <ModalContainer key="modal-container" />

      <header className=classes.header>
        <a href='/' className=classes.logo>
          <LogoImage {...@props} className=classes.logo />
        </a>
      </header>

      <main {...@props} role='main' className=classes.main>
        <div {...@props}
          className="c-layout-minimal__container #{@props.cssModifier}" />
      </main>

      {if @props.showFooter
        <TempFooter
          key='temp-footer'
          cssUtility=classes.footer />}

      {if @props.showHelpFooter
        <HelpFooter {...@props} {...footer} key='temp-footer'
          cssUtility=classes.footer />}
    </div>
