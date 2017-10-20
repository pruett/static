[
  _
  React

  ResponsivePicture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'

  require 'components/mixins/mixins'

  require './gallery_hero.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gallery-hero'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    headline: ''
    description: ''
    alt_text: ''
    source_images: []

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "
    imageBlock: "
      #{@BLOCK_CLASS}__image-block
    "
    image: "
      #{@BLOCK_CLASS}__image
    "
    textBlock: "
      #{@BLOCK_CLASS}__text-block
    "
    headline: "
      #{@BLOCK_CLASS}__headline
    "
    description: "
      #{@BLOCK_CLASS}__description
    "

  classesWillUpdate: ->
    textBlock:
      "-#{@props.text_color}": true

  render: ->
    classes = @getClasses()

    sizes =
      xs: [
        break: 320
        image: 768
      ]
      s: [
        break: 768
        image: 1600
      ]
      m: [
        break: 1600
        image: 2400
      ]

    <div className=classes.block>
      <div className=classes.imageBlock>
        <ResponsivePicture
          sizes=sizes
          cssModifier=classes.image
          altText=@props.alt_text
          sourceImages=@props.source_images />
      </div>

      {if @props.headline or @props.description
        <div className=classes.textBlock>
          <h1 className=classes.headline children=@props.headline />
          <h2 className=classes.description children=@props.description />
        </div>}
    </div>
