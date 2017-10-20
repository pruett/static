[
  React
  _

  Typekit
  LayoutDefault
  Loader
  Killscreen

  Mixins
] = [
  require 'react/addons'
  require 'lodash'

  require 'components/atoms/scripts/typekit/typekit'
  require 'components/layouts/layout_default/layout_default'
  require 'components/molecules/collections/killscreen/loader/loader'
  require 'components/organisms/collections/killscreen/killscreen'

  require 'components/mixins/mixins'

]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  CONTENT_PATH: '/killscreen'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/kill-screen'
      handler: 'Killscreen'
      title: 'Warby Parker x Kill Screen'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  componentDidMount: ->
    @commandDispatcher 'scripts', 'load',
      name: 'phaser'
      src: '/assets/killscreen/phaser.min.js'
      timeout: 50000

  receiveStoreChanges: -> [
    'scripts'
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH
    phaserLoaded = _.get @getStore('scripts'), 'phaser.loaded', false
    # In order to keep Nav and Footer from collapsing
    # when using CSS parallax effetct,
    # the layout is wrapped in a parallax div
    <div className='c-killscreen__parallax'>
      <LayoutDefault cssModifier='-full-page' {...@props}>
        <ReactCSSTransitionGroup transitionName="logo" transitionEnterTimeout={1000} transitionLeaveTimeout={1000} transitionAppear={true}>
          {
            if content and phaserLoaded
              <Killscreen content=content key='kill' />
            else
              <Loader key='loader' />
          }
        </ReactCSSTransitionGroup>
      </LayoutDefault>
    </div>
