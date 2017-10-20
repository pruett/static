[
  _
  React

  Mixins
  FrameMixin

  CoreHero
  CoreCallout
  CoreHTOCallout
  CoreFramesGrid
] = [

  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
  require 'components/mixins/collections/frame_handling_mixin'


  require 'components/molecules/collections/core/hero/hero'
  require 'components/molecules/collections/core/callout/callout'
  require 'components/molecules/collections/core/hto_callout/hto_callout'
  require 'components/molecules/collections/core/frames_grid/frames_grid'

  require './collection.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collection-spring-2016'

  mixins: [
    Mixins.locale
    Mixins.context
    Mixins.dispatcher
    Mixins.classes
    FrameMixin
  ]

  getModifiers: ->
    hero:
      block: "
        #{@BLOCK_CLASS}__hero
      "
      price: "
        #{@BLOCK_CLASS}__price-text
      "
      logo: "
        #{@BLOCK_CLASS}__logo-wrapper
      "
      contentWrapper: "
        #{@BLOCK_CLASS}__content-wrapper
        u-reset u-fs20 u-color--black
      "
      copyWrapper: "
        #{@BLOCK_CLASS}__copy-wrapper
      "
      HeaderText: "
        #{@BLOCK_CLASS}__header-text
        u-ttu u-fwb
      "
      heroWrapper: "
        #{@BLOCK_CLASS}__hero-wrapper--#{@props.version}
      "
      pdpLinkWrapper: "
        #{@BLOCK_CLASS}__pdp-link-hero-wrapper
      "
      staticContentWrapper:
        unless @props.version is 'women'
          "#{@BLOCK_CLASS}__static-content-wrapper
          u-color--black"
        else
          "#{@BLOCK_CLASS}__static-content-wrapper--women
          u-color--black"
      staticLogo: "
        #{@BLOCK_CLASS}__static-logo
      "
      staticHeaderText: "
        #{@BLOCK_CLASS}__static-header-text
        u-ttu u-fwb
      "
      staticCopy: "
        #{@BLOCK_CLASS}__static-copy
      "
      staticPriceText: "
        #{@BLOCK_CLASS}__static-price-text
      "
    topCallout:
      copy: "
        #{@BLOCK_CLASS}__callout-copy-wrapper
      "
      markdownWrapper:
        if @props.version is 'men'
          "u-tac u-color--black
          #{@BLOCK_CLASS}__markdown-wrapper-left"
        else
          "u-tac u-color--black
          #{@BLOCK_CLASS}__markdown-wrapper-right"
    middleCallout:
      copy: "
        #{@BLOCK_CLASS}__callout-copy-wrapper
      "
      markdownWrapper:
        if @props.version is 'men'
          "u-tac u-color--black
          #{@BLOCK_CLASS}__markdown-wrapper-right"
        else
          "u-tac u-color--black
          #{@BLOCK_CLASS}__markdown-wrapper-left"
    hto_callout:
      block: "
        #{@BLOCK_CLASS}__hto-callout
      "
      picture: "
        #{@BLOCK_CLASS}__hto-callout-picture
      "
      copy: "
        #{@BLOCK_CLASS}__hto-callout-copy
        u-color--black
      "
      body: "
        #{@BLOCK_CLASS}__hto-callout-body
      "
      link: "
        #{@BLOCK_CLASS}__hto-callout-link
      "
      arrow: "
        #{@BLOCK_CLASS}__hto-callout-arrow
      "
      header: "
        #{@BLOCK_CLASS}__hto-callout-header
        u-ttu u-fwb
      "

  getDefaultProps: ->
    gaListModifier: 'collection_spring2016'

  getSizes: ->
    hero:
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
    callout:
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

  componentDidMount: ->
    @getProductImpressions(@props.version)

  render: ->
    country = @getLocale('country')
    frames = @getGroupedFrames(@props.version)
    sizes = @getSizes()
    modifiers = @getModifiers()

    #TODO: use context mixin/getFeature 'homeTryOn' as flag for HTO callout
    <div className=@BLOCK_CLASS>
      <CoreHero
        content={_.get @props, 'content.header'}
        version=@props.version
        slideDuration=7000
        cssModifiers=modifiers.hero
        heroSizes=sizes.hero
        headerText=true
       />
      <CoreFramesGrid
        frames=frames[1]
        defaultPosition=1
        version=@props.version
        listModifier=@props.gaListModifier
      />
      <CoreCallout
        content={_.get @props, 'content.callout_block_1'}
        version=@props.version
        sizes=sizes.callout
        cssModifiers=modifiers.topCallout
      />
      <CoreFramesGrid
        frames=frames[2]
        defaultPosition=3
        version=@props.version
        listModifier=@props.gaListModifier
      />
      <CoreCallout
        content={_.get @props, 'content.callout_block_2'}
        version=@props.version
        sizes=sizes.callout
        cssModifiers=modifiers.middleCallout
      />
      <CoreFramesGrid
        frames=frames[3]
        defaultPosition=5
        version=@props.version
        listModifier=@props.gaListModifier
      />
      {
        if country is 'US'
          <CoreHTOCallout
            content={_.get @props, 'content.callout_block_hto'}
            cssModifiers=modifiers.hto_callout
            sizes=sizes.callout
          />
      }
    </div>
