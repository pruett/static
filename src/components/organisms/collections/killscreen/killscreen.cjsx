[
  _
  React

  Picture
  Hero
  Callout
  FrameContainer
  GameContainer

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/molecules/collections/killscreen/hero/hero'
  require 'components/molecules/collections/killscreen/callout/callout'
  require 'components/molecules/collections/killscreen/frame_container/frame_container'
  require 'components/molecules/collections/killscreen/game_container/game_container'

  require 'components/mixins/mixins'

  require './killscreen.scss'

]

module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
    Mixins.classes
  ]

  BLOCK_CLASS: 'c-killscreen'

  propTypes:
    content: React.PropTypes.object

  getDefaultProps: ->
    content: {}

  componentDidMount: ->
    @dispatchProductImpression()

  dispatchProductImpression: ->

    ctas = _.get @props, 'content.frame.ctas', []

    impressions = _.map ctas, (frame) ->
      ga = _.get frame, 'ga', {}

      brand: 'Warby Parker'
      category: 'Eyeglasses'
      list: 'CollectionKillscreen'
      name: 'Burke'
      position: 1
      id: ga.id
      url: frame.href

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productImpression'
      products: impressions

  getStaticClasses: ->
    wrapper: "
      #{@BLOCK_CLASS}__wrapper
      u-pb72--600 u-pb0--900
      u-mla u-mra
    "
    parallaxLayerBase: "
      #{@BLOCK_CLASS}__parallax-layer-base
    "
    parallaxLayerBack: "
      #{@BLOCK_CLASS}__parallax-layer-back
    "

  render: ->
    { hero, callout, frame, game_container, sold_out } = @props.content or {}

    @classes = @getClasses()

    <div className=@BLOCK_CLASS>
      <div className=@classes.wrapper>
        <div className=@classes.parallaxLayerBack />
        <div className=@classes.parallaxLayerBase>
          <Hero {...hero} soldOut=sold_out />
          <Callout {...callout} />
          <FrameContainer {...frame} soldOut=sold_out />
          <GameContainer {...game_container} />
        </div>
      </div>
    </div>
