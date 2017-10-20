[
  React

  MarkdownComponent
  ResponsivePicture

  Mixins

] = [
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'

  require 'components/mixins/mixins'


  require './callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-winter-2015-callout'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''
    images: []
    sizes:
      mobile: [
        break: 0
        image: 500
      ]
      tablet: [
        break: 640
        image: 960
      ]
      desktop: [
        break: 960
        image: 2000
      ]

  getStaticClasses: ->
    block: [
      "#{@BLOCK_CLASS}"
      "#{@props.cssCalloutModifier}"
    ]
    textWrapper: [
      "#{@BLOCK_CLASS}__text-wrapper"
      "#{@props.cssModifierText}"
      "u-reset u-ffs u-fs16"
    ]
    divider: [
      "#{@BLOCK_CLASS}__divider"
      "#{@props.cssModifierDividerColor}"
      "#{@props.cssModifierDividerPosition}"
    ]
    imageWrapper: "
      #{@BLOCK_CLASS}__image-wrapper
    "
    image: "
      #{@BLOCK_CLASS}__image
    "
    markdownWrapper: [
      "#{@BLOCK_CLASS}__markdown-wrapper"
      "#{@props.cssModifierText}"
    ]
    markdownText : [
      "#{@BLOCK_CLASS}__markdown-text"
      "u-reset u-ffs u-fs16"
    ]

  render: ->
    classes = @getClasses()
    <div className=classes.block>
      <div className=classes.imageWrapper>
        <ResponsivePicture
          sourceImages={if not @props.hto then @props[@props.version] else @props.images}
          sizes=@props.sizes
          cssModifier=classes.image
        />
        <MarkdownComponent
          className=classes.markdownWrapper
          cssBlock=classes.markdownText
          rawMarkdown=@props.text
        />
        <div className=classes.divider />
      </div>
    </div>
