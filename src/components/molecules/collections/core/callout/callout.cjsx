[
  _
  React

  ResponsivePicture
  MarkdownComponent

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'


  require './callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collection-core-callout'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifiers:
      block: ''
      copyWrapper: ''
      pictureWrapper: ''
      markdownWrapper: ''
      divider: ''
      pdpLinkWrapper: ''
      frameName: ''
      frameColor: ''

  getStaticClasses: ->
    cssModifiers = @props.cssModifiers or {}

    block: "
      #{@BLOCK_CLASS} #{cssModifiers.block}
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper #{cssModifiers.copyWrapper}
      u-reset u-fs20 u-tac
    "
    pictureWrapper: "
      #{@BLOCK_CLASS}__picture-wrapper #{cssModifiers.pictureWrapper}
    "
    markdownWrapper: "
      #{@BLOCK_CLASS}__markdown-wrapper #{cssModifiers.markdownWrapper}
    "
    divider: "
      #{@BLOCK_CLASS}__divider #{cssModifiers.divider}
    "
    pdpLinkWrapper: [
      "#{@BLOCK_CLASS}__pdp-link-wrapper"
      _.get @props, "content.pdp_links[#{@props.version}].css_modifier"
      'u-ffs'
    ]
    frameName: "
      #{@BLOCK_CLASS}__frame-name #{cssModifiers.frameName}
      u-fws
    "
    frameColor: "
      #{@BLOCK_CLASS}__frame-color #{cssModifiers.frameColor}
      u-fsi
    "

  render: ->

    classes = @getClasses()
    pdpLinks = _.get @props, "content.pdp_links[#{@props.version}]", {}

    <div className=@BLOCK_CLASS>
      <ResponsivePicture
        sizes=@props.sizes
        sourceImages={_.get @props, "content[#{@props.version}]"}
        cssModifier=classes.pictureWrapper
      />
      <MarkdownComponent
        className=classes.copyWrapper
        cssBlock=classes.markdownWrapper
        rawMarkdown={_.get @props, 'content.text'}
      />
      {
        if @props.showDivider
          <div className=classes.divider />
      }
      {
        unless _.isEmpty pdpLinks
          <div className=classes.pdpLinkWrapper>
            <div
              className=classes.frameName
              children=pdpLinks.frame_name
            />
            <div
              className=classes.frameColor
              children=pdpLinks.frame_color
            />
          </div>
      }
    </div>
