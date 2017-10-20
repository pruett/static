# Deprecating in favor of modular version

[
  _
  React

  Markdown
  Picture
  CTA
  Rsvg

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/buttons/cta/cta'
  require 'components/quanta/rsvg/rsvg'

  require 'components/mixins/mixins'

  require './callout.scss'
  require './variations/bapgap.scss'
  require './variations/standard.scss'
  require './variations/hero/hto.scss'
  require './variations/hero/spring_2016.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout'

  mixins: [
    Mixins.analytics
    Mixins.dispatcher
    Mixins.image
  ]

  getDefaultProps: ->
    links: []
    linkTarget: null
    titles: []
    descriptions: []
    images: []
    analytics: {}
    variations: {}

    reverseSourceOrder: false

  pushPromoEvent: ->
    if _.isObject @props.analytics
      @commandDispatcher 'analytics', 'pushPromoEvent',
        type: 'promotionClick'
        promos: [@props.analytics]

  handleClick: (i, event) ->
    @pushPromoEvent()
    @trackInteraction @getAnalyticsSlug(i), event

  getClass: (opts = {}) ->
    klass = ''

    unless _.isEmpty _.get(@props, "variations.block")
      # Base Class
      klass += @BLOCK_CLASS
      klass += "__#{opts.element}" if opts.element isnt 'block'

      variation = _.get(@props, "variations.#{opts.element}")
      variationBlock = _.get(@props, "variations.block")
      klass = "#{klass} #{klass}--#{variation}" if variation

      if variation or variationBlock
        # Create variation of element (e.g. standard, ttr, ttb)
        klassVar = " #{@BLOCK_CLASS}"
        klassVar += "--#{variationBlock}" if variationBlock

        if opts.element isnt 'block'
          klassVar += "__#{opts.element}" if opts.element isnt 'block'
          klassVar = "#{klassVar} #{klassVar}--#{variation}" if variation

        klass += klassVar

    # Size Modifiers (e.g. -s, -m, -l, -xl)
    klass += " -#{opts.size}" if opts.size

    # Props passed down as utilities. ( e.g. u-reset, u-button, etc...)
    if _.get(@props, "cssUtilities.#{opts.element}")
      klass += " #{@props.cssUtilities[opts.element]}"

    if _.get(@props, "cssModifiers.#{opts.element}")
      klass += " #{@props.cssModifiers[opts.element]}"

    klass

  getAnalyticsSlug: (i) ->
    slug = _.camelCase _.get(@props, 'analytics.id', 'cta')

    # Add index of multiple.
    if _.size(@props.links) > 1
      "promo-click-#{slug}#{i + 1}"
    else
      "promo-click-#{slug}"

  renderTitle: (title, i) ->
    <Markdown
      key="title-#{title.type}-#{i}"
      rawMarkdown=title.value
      className={@getClass({element: 'title', size: title.type})}
      cssBlock="#{@BLOCK_CLASS}__markdown"/>

  renderDescription: (description, i) ->
    <Markdown
      key="description-#{description.type}-#{i}"
      rawMarkdown=description.value
      className={@getClass({element: 'description', size: description.type})}
      cssBlock="#{@BLOCK_CLASS}__markdown" />

  renderLink: (link, i) ->
    linkVariation = _.get(@props, 'variations.link')

    if linkVariation
      <CTA
        onClick=@pushPromoEvent
        analyticsSlug={@getAnalyticsSlug(i)}
        tagName='a'
        variation=linkVariation
        key="link-#{link.type}-#{i}"
        href=link.route
        cssModifier={@getClass({element: 'link', size: link.type})}
        children=link.value />
    else
      <a href=link.route
        target=@props.linkTarget
        key="a-#{link.type}-#{i}"
        onClick={@handleClick.bind(@, i)}
        className={@getClass({element: 'link', size: link.type})}
        children=link.value />

  renderImagery: ->
    return false unless _.isArray(@props.images) and @props.pictureAttrs

    pictureAttrs = _.merge {}, @props.pictureAttrs,
      img: className: @getClass(element: 'image')

    <div className={@getClass(element: 'imagery')} key='imagery'>
      <Picture
        key='picture'
        cssModifier={@getClass(element: 'picture')}
        children={@getPictureChildren(pictureAttrs)}/>
    </div>

  render: ->
    logoAttrs = _.merge {}, @props.logoAttrs,
      img: className: @getClass(element: 'logo')

    <div
      className={@getClass(element: 'block')}
      id={_.get(@props, 'analytics.id')}>

      <div className={@getClass(element: 'content')}>

          {@renderImagery() unless @props.reverseSourceOrder}

          <div className={@getClass(element: 'wrapper')}>
            <div className={@getClass(element: 'copy')}>

              {unless _.isEmpty @props.logoAttrs
                <Picture
                  key='logo'
                  cssModifier={@getClass(element: 'picture')}
                  children={@getPictureChildren(logoAttrs)} />}

              {unless _.isEmpty @props.logo
                <Rsvg {...@props.rsvg}
                  key='rsvg'
                  cssModifier={@getClass(element: 'logo')} />}

              {_.map @props.titles, @renderTitle}

              {_.map @props.descriptions, @renderDescription}

              {_.map @props.links, @renderLink}

            </div>
          </div>

          {@renderImagery() if @props.reverseSourceOrder}

        </div>
    </div>
