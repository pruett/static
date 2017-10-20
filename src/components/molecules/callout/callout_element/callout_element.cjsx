[
  _
  React

  Markdown
  Picture
  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout-element'

  mixins: [
    Mixins.analytics
    Mixins.callout
    Mixins.dispatcher
    Mixins.image
  ]

  propTypes:
    constraints: React.PropTypes.array
    css_utilities: React.PropTypes.string
    flip: React.PropTypes.bool
    link: React.PropTypes.object
    picture: React.PropTypes.object
    text: React.PropTypes.object
    type: React.PropTypes.oneOf ['text', 'picture', 'link']
    typeIndex: React.PropTypes.number

  handleClick: (event) ->
    return unless _.isObject @props.analytics
    @commandDispatcher('analytics', 'pushPromoEvent',
      type: 'promotionClick'
      promos: [@props.analytics]
    )

    @trackInteraction(
      "promo-click-#{_.camelCase _.get(@props, 'analytics.id', 'cta')}#{@props.typeIndex}"
      event
    )

  getId: ->
    # Generate ID for style tag.
    "module-#{_.camelCase @props.moduleName}-#{@props.type}-#{@props.typeIndex}"

  getCssUtilities: (klass) ->
    # Get all 'css_' utilities.
    klasses = _.reduce @props[@props.type], (acc, attr, key) ->
      acc.push attr if _.startsWith key, 'css'
      acc
    , []

    # Only set 'u-d*' is trying to hide something.
    if _.some @props.constraints, { width: 0 }
      klasses.push _.reduce @SIZES, @reduceSizeToDisplayUtility, ''

    # Enable override of standard utilities with css_utilities
    klasses.concat(@props.css_utilities or klass).join ' '

  mapSizeAndAddImageData: (size) ->
    # Use SIZES to generate image properties.
    images = _.get @props, 'picture.images', []
    image = _.find(images, size: size.name) or {}

    constraint = _.find @props.constraints, size: size.name

    if constraint?.width?
      width = constraint.width
      sizes = "#{constraint.width}px"
    else
      width = size.widthMax
      sizes = '100vw'

    image.url = @getEmptyImage() unless width # If hidden, load blank image.
    image.widths = _.range width, width * 2 , 100
    image.mediaQuery = "(min-width: #{size.widthMin}px)"
    image.quality = image.quality or 70
    image.sizes = sizes
    image

  mapSourceAndUpdateUrl: (source, index, sources) ->
    # Get closest URL if no url provided or filled with blank image.
    return source if source.url
    source.url = _.find(sources.slice(index + 1), 'url')?.url
    source

  reduceSizeToDisplayUtility: (memo, size) ->
    variation = if size.name is 'mobile' then '' else "--#{size.widthMin}"
    constraint = _.find @props.constraints, size: size.name

    # Hide if width available and set to 0/null.
    if constraint and not constraint.width
      "#{memo} u-dn#{variation}"
    else
      "#{memo} u-db#{variation}"

  reduceSizeToStyle: (memo, size) ->
    # Generate style from SIZES array if passing width.
    constraint = _.find @props.constraints, size: size.name
    return memo unless constraint?.width?

    "#{memo}
      @media (min-width: #{size.widthMin}px) {
        ##{@getId()} {
          width: #{constraint.width}px;
        }
      }"

  reduceSourceToSrcSet: (memo, source, index, sources) ->
    # Generate srcSet attributes.
    memo.widths = memo.widths.concat source.widths
    memo.sizes = "#{memo.sizes} #{source.sizes}"
    memo.sizes = "#{memo.sizes}, " if sources.length isnt index + 1
    memo

  renderStyle: ->
    # Loop through SIZES mobile to desktop and print out style tags.
    <style key='style-text'
      dangerouslySetInnerHTML={
        __html: @SIZES.slice().reverse().reduce @reduceSizeToStyle, ''
      }/>

  renderImagery: ->
    sizes = @SIZES.map @mapSizeAndAddImageData
    sources = sizes.map @mapSourceAndUpdateUrl
    fallbackAlt = _.lowerCase("#{@props.moduleName} logo")
    alt = _.get(@props, 'picture.alt') || fallbackAlt

    <Picture
      key='picture'
      id=@getId()
      cssModifier={@getCssUtilities('u-db u-ma u-mw100p')}
      children={@getPictureChildren(
        sources: sources
        img:
          className: 'u-db u-w100p'
          alt: alt
      )} />

  renderElement: ->
    switch @props.type
      when 'link'
        # Generates button link.
        # href: Routeable link.
        # value: Text in link.
        # css_utilities_button: White or blue via utilities.
        link = @props.link or {}
        target = if _.isEmpty(link.target) then null else link.target
        style = if _.isEmpty(link.border_color) then {} else borderColor: link.border_color

        <a href=link.href
          target=target
          key=@props.type
          style=style
          onClick={@handleClick}
          className={@getCssUtilities('u-fs16 u-fws u-button -button-modular')}
          children=link.value />

      when 'text'
        # Must use another text element for line-breaks.
        # css_utilities_size: Heading or Body via utilities
        # css_utilities_margin_bottom: Setting via utilities
        # color: Hex value for collection colors.
        text = @props.text or {}
        value = "#{text.value}"
        if @props.index is 0
          # If first element in array, set as h1.
          value = "# #{value}"

        [
          @renderStyle()
          <Markdown
            id=@getId()
            style={if _.isEmpty(text.color) then {} else color: text.color}
            rawMarkdown=value
            cssBlock='u-reset'
            cssModifiers={h1: "u-reset"}
            className={@getCssUtilities('u-db u-ma u-mw100p')} />
        ]

      when 'picture'
        # Can be a Img or Picture tag, based on sources.
        # alt: Alt image tag.
        # css_utilities_margin_bottom: Setting via utilities.
        # images: Array of sources with url/quality/size
        [
          @renderStyle()
          @renderImagery()
        ]

      else
        false

  render: ->
    <div className="#{@BLOCK_CLASS} #{@BLOCK_CLASS}--#{@props.type}"
      children={@renderElement()} />
