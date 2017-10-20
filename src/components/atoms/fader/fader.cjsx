[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './fader.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-fader'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  KEYFRAME_PREFIXES: [
    '@-webkit-keyframes',
    '@keyframes'
  ]

  ANIMATION_PREFIXES: [
    'animation'
    'WebkitAnimation'
    'MozAnimation'
    'OAnimation'
    'msAnimation'
  ]

  getDefaultProps: ->
    time_delay: 3
    time_cross: 1

    cssVariation: ''
    cssVariationList: ''
    cssModifierPicture: ''
    cssModifierImage: ''

    alt: ''
    sizes: ''
    srcSets: []

  reduceKeyframe: (result, prefix) ->
    duration = (@props.time_delay + @props.time_cross) * @props.srcSets.length

    result = result +
      """
        #{prefix} xfade {
          0% {
            opacity:1;
          }
          #{(@props.time_delay/duration)*100}% {
            opacity:1;
          }
          #{(1/@props.srcSets.length)*100}% {
            opacity:0;
          }
          #{100-@props.time_cross * 100/duration}% {
            opacity:0;
          }
          100% {
            opacity:1;
          }
        }

      """

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssVariation}"
    list: "
      #{@BLOCK_CLASS}__list
      #{@props.cssVariationList}
      u-list-reset
    "
    item: "
      #{@BLOCK_CLASS}__item"
    picture: "
      #{@BLOCK_CLASS}__picture
      #{@props.cssModifierPicture}
    "
    image: "
      #{@BLOCK_CLASS}__image
      #{@props.cssModifierImage}
    "

  renderPictures: (srcSet, index) ->
    <li className=@classes.item style={@getAnimationProperties(index)}>
      <Img
        srcSet=srcSet
        sizes=@props.sizes
        className=@classes.image
        alt="#{@props.alt}-#{index}" />
    </li>

  getAnimationProperties: (index) ->
    delay = (@props.time_cross + @props.time_delay) * -index
    duration = (@props.time_delay + @props.time_cross) * @props.srcSets.length

    _.reduce @ANIMATION_PREFIXES, (result, prefix) ->
      result["#{prefix}Duration"] = "#{duration}s"
      result["#{prefix}Delay"] = "#{delay}s"
      result
    , {}

  render: ->
    return false unless _.isArray @props.srcSets

    @classes = @getClasses()
    style = _.reduce @KEYFRAME_PREFIXES, @reduceKeyframe, ''

    <div className=@classes.block>

        <style dangerouslySetInnerHTML={__html: style} />

        <ul className=@classes.list
          children={_.map(@props.srcSets, @renderPictures)} />

    </div>
