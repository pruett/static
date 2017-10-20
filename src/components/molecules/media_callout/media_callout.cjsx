[
  _
  React

  Markdown
  Picture
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/images/picture/picture'

  require './media_callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-media-callout'

  propTypes:
    image: React.PropTypes.string
    image_tablet: React.PropTypes.string
    image_mobile: React.PropTypes.string
    title: React.PropTypes.string
    detail: React.PropTypes.string
    isTouch: React.PropTypes.bool
    isActive: React.PropTypes.bool
    cssModifierMedia: React.PropTypes.string
    cssUtilityHeadline: React.PropTypes.string

  getDefaultProps: ->
    image: ''
    image_tablet: ''
    image_mobile: ''
    title: ''
    detail: ''
    isTouch: false
    isActive: false
    cssModifierMedia: ''
    cssUtilityHeadline: ''

  render: ->
    classes =
      block: "
        #{@BLOCK_CLASS}
        #{['-active' if @props.isActive]}
        #{['-not-touch' unless @props.isTouch]}
        "
      media: "
        #{@BLOCK_CLASS}__media
        #{@props.cssModifierMedia}
        #{['-not-touch' unless @props.isTouch]}
        "
      mediaImage: "
        #{@BLOCK_CLASS}__image
        #{['-not-touch' unless @props.isTouch]}
        #{['-add-padding' if @props.isPadding]}
        "
      caption: "
        #{@BLOCK_CLASS}__caption
        #{['-not-touch' unless @props.isTouch]}
        "
      captionHeadline: "
        #{@BLOCK_CLASS}__headline
        u-reset u-ffs
        #{@props.cssUtilityHeadline}
        #{['-not-touch' unless @props.isTouch]}
        "
      captionBody: "
        #{@BLOCK_CLASS}__body
        #{['-not-touch' unless @props.isTouch]}
        u-reset u-ffs
        "

    <div className=classes.block>
      <div className=classes.media>
        <Picture cssModifier=classes.mediaImage>
          <source srcSet=@props.image media="(min-width: 960px)"/>
          <source srcSet=@props.image_tablet media="(min-width: 500px)"/>
          <img srcSet=@props.image_mobile />
        </Picture>
      </div>
      <div className=classes.caption>
        <h3 className=classes.captionHeadline>
          {@props.title}
        </h3>
        <Markdown
          className=classes.captionBody
          cssBlock="#{@BLOCK_CLASS}__body"
          rawMarkdown=@props.detail />
      </div>
    </div>
