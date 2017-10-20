[
  _
  React

  ResponsivePicture
  MarkdownComponent
  RightArrow

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'
  require 'components/molecules/markdown/markdown'
  require 'components/quanta/icons/right_arrow/right_arrow'


  require 'components/mixins/mixins'


  require './hto_callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collection-core-hto-callout'

  mixins: [
    Mixins.classes
    Mixins.analytics
  ]

  getDefaultProps: ->
    gaSlug : "LandingPage-clickLink-HTO"
    cssModifiers:
      block: ''
      picture: ''
      copy: ''
      body: ''
      link: ''
      arrow: ''
      header: ''

  getStaticClasses: ->
    cssModifiers = @props.cssModifiers or {}

    block: "
      #{@BLOCK_CLASS} #{cssModifiers.block}
    "
    pictureWrapper: "
      #{@BLOCK_CLASS}__picture-wrapper #{cssModifiers.picture}
    "
    copyWrapper: "
      #{@BLOCK_CLASS}__copy-wrapper #{cssModifiers.copy} u-tac
    "
    bodyWrapper: "
      #{@BLOCK_CLASS}__body #{cssModifiers.body}
    "
    linkWrapper: "
      #{@BLOCK_CLASS}__link-wrapper #{cssModifiers.link}
    "
    arrow: "
      #{@BLOCK_CLASS}__arrow #{cssModifiers.arrow}
    "
    header: "
      #{@BLOCK_CLASS}__header #{cssModifiers.header}
    "
  handleClick: ->
    @trackInteraction @props.gaSlug

  render: ->
    classes = @getClasses()

    <div className=classes.block >
      <ResponsivePicture
        sizes=@props.sizes
        sourceImages={_.get @props, 'content.images'}
        cssModifier=classes.pictureWrapper
      />
      <section className=classes.copyWrapper >
        <div
          className=classes.header
          children={_.get @props, 'content.header_text'}
        />
        <p
          className=classes.body
          children={_.get @props, 'content.body_text'}
        />
        <div className=classes.linkWrapper >
          <a onClick={@handleClick} href={_.get @props, 'content.cta_link'}>
            <span
              children={_.get @props, 'content.cta_text'}
              className=classes.ctaText
            />
            <RightArrow
              cssModifier=classes.arrow
            />
          </a>
        </div>
      </section>
    </div>
