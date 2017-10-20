[
  _
  React

  Picture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './marquee.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-marquee'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    sources: React.PropTypes.arrayOf(
      React.PropTypes.shape
        size: React.PropTypes.oneOf ['small', 'large']
        image: React.PropTypes.string
    )
    alt: React.PropTypes.string

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-db"
    img:
      "#{@BLOCK_CLASS}__img"

  sourceSpecs:
    small:
      widths: _.range 300, 1700, 200
      mediaQuery: '(min-width: 0px)'
    large:
      widths: _.range 900, 3900, 300
      mediaQuery: '(min-width: 900px)'

  getSourceSpecs: (sources, specs) ->
    _.reduce ['large', 'small'], (acc, size) =>
      source = _.find sources, size: size
      source.url = source.image
      acc[size] = _.assign source, specs[size]
      acc
    , {}

  render: ->
    classes = @getClasses()
    sources = @getSourceSpecs @props.sources, @sourceSpecs
    pictureAttrs =
      sources: [sources.large, sources.small]
      img:
        alt: @props.alt
        className: classes.img

    <Picture cssModifier=classes.block
      children={@getPictureChildren pictureAttrs} />
