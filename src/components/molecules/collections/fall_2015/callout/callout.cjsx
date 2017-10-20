[
  React

  Picture

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-fall-2015-callout'

  MIN_WIDTH_TABLET: '720px'
  MIN_WIDTH_DESKTOP: '960px'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    text: "One of our literary touchstones for the season is John Keats’s ode “To Autumn”—33 lines
        marveling at the marvel-worthy elements of the season: the transition from harvest to winter,
        the mixture of abundance and drowsiness, the colors and sights of a changing landscape."
    cssModifier: ''
    cssUtility: ''
    cssModifierDivider: '-light-gray'
    cssModifierText: '-text-right -vertical-center'
    image: ''
    alt_text: 'small pinecones'
    cssModifierImage: '-image-left'

  getStaticClasses: ->
    text: [
      "#{@BLOCK_CLASS}__body-text"
      'u-reset u-ffs -fall-2015-responsive-type'
    ]
    block: [
      "#{@BLOCK_CLASS}"
      "#{@props.cssModifier}"
      "#{@props.cssUtility}"
    ]
    divider: [
      "#{@BLOCK_CLASS}__divider"
      "#{@props.cssModifierDivider}"
    ]
    image: [
      "#{@BLOCK_CLASS}__image"
      "#{@props.cssModifierImage}"
    ]
    picture: "#{@BLOCK_CLASS}__picture"
    textWrapper: [
      "#{@BLOCK_CLASS}__text-wrapper"
      "#{@props.cssModifierText}"
    ]

  render: ->
    classes = @getClasses()
    <div className=classes.block>
      <Picture cssModifier=classes.picture>
        <source
          className=classes.image
          media="(min-width: #{@MIN_WIDTH_DESKTOP})"
          srcSet={"#{@props.image} 1x, #{@props.image_2x} 2x"} />
        <source
          className=classes.image
          media="(min-width: #{@MIN_WIDTH_TABLET})"
          srcSet={@props.image_tablet ? @props.image} />
        <source
          className=classes.image
          srcSet={"#{@props.image_mobile} 1x, #{@props.image_mobile_2x} 2x"} />
        <img
          className=classes.image
          srcSet=@props.image
          alt=@props.alt_text />
      </Picture>
      <div className=classes.textWrapper>
        <div className=classes.divider />
        <p className=classes.text children=@props.text />
      </div>
    </div>
