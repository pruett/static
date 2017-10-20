[
  React

  Picture

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './short.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-hero-short'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    alt: React.PropTypes.string
    cssModifier: React.PropTypes.string
    sources: React.PropTypes.arrayOf(
      React.PropTypes.shape(
        mediaQuery: React.PropTypes.string
        sizes: React.PropTypes.string
        url: React.PropTypes.string
        widths: React.PropTypes.array
      )
    )

  getDefaultProps: ->
    alt: ''
    cssModifier: ''
    sources: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-w100p
      u-db
      u-oh"
    image:
      "#{@BLOCK_CLASS}__image
      u-h100p
      u-pr
      u-center-x"

  render: ->
    classes = @getClasses()

    pictureAttrs =
      sources: @props.sources
      img:
        alt: @props.alt or ''
        className: classes.image

    <Picture
      cssModifierPicture=classes.block
      cssModifierImg=classes.image
      children={@getPictureChildren pictureAttrs} />
