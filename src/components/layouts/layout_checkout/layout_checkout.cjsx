[
  _
  React

  CheckoutContainer
  ModalContainer
  Banner
  UnsupportedBrowserNotice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/container/container'
  require 'components/organisms/modals/modal_container/modal_container'
  require 'components/atoms/banner/banner'
  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.context
  ]

  propTypes:
    appState: React.PropTypes.object
    cssMainModifier: React.PropTypes.string

  getDefaultProps: ->
    appState: {}
    cssMainModifer: ''

  render: ->
    <div className='u-template'>
      <UnsupportedBrowserNotice />

      {if @getExperimentVariant('universalBanner') is 'enabled'
        <Banner />}

      <ModalContainer key="modal-container" />

      <main role='main' className="u-template__main u-oh #{@props.cssMainModifier}">
        <CheckoutContainer {...@props} />
      </main>

    </div>
