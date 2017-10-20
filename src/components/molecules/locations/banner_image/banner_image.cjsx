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

  require './banner_image.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-banner-image'

  propTypes:
    images: React.PropTypes.arrayOf(
      React.PropTypes.shape
        url: React.PropTypes.string
        minWidth: React.PropTypes.string # Includes unit.
        range: React.PropTypes.array
    )

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    image:
      "#{@BLOCK_CLASS}__image"

  render: ->
    classes = @getClasses()

    pictureAttrs =
      sources: @props.images.map (img) ->
        url: img.url
        widths: img.range
        mediaQuery: "(min-width: #{img.minWidth})"
      img:
        alt: 'Retail locations'
        className: classes.image

    <div className=classes.block>
      <Picture children={@getPictureChildren pictureAttrs} />
    </div>
