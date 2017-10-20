[
  _
  React

  Markdown

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './copy.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-curated-copy'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaultProps: ->
    css_utility_frame_color: 'u-color--dark-gray-alt-3'
    css_utility_frame_description: 'u-color--dark-gray-alt-3'
    css_utility_frame_name: 'u-color--dark-gray'
    css_utility_link: ''
    copy_align: 'center'
    manageProductClick: ->
    product: {}
    show_description: true
    show_links: true
    show_price: false
    text_align: 'right'
    two_up: false
    white_links: false
    women_only: false

  getStaticClasses: ->
    block: '
      u-db
      u-fs18
    '
    markdown: '
      u-reset
    '
    title: "
      u-mb6 u-reset
      u-ffs u-fws
      #{@props.css_utility_frame_name}
    "
    subtitle: "
      u-reset
      u-fsi u-fwl
      u-fs18 u-fs20--600 u-fs20--900 u-fs24--1200
      u-mb12 u-mb18--900
      u-ffs u-mb6
      #{@props.css_utility_frame_color}
    "
    links: '
      u-mt24
    '
    link: "
      u-bbss u-bbw2 u-bbw0--900
      u-pb6
      u-fws
      u-fs16 u-fs18--900
      u-wsnw
      u-color--blue
      #{@props.css_utility_link}
    "
    description: "
      u-ffss u-fs16 u-fs18--900 u-mb6
      #{@props.css_utility_frame_description}
    "
    price: "
      u-fs18 u-fs20--600 u-fs20--900 u-fs24--1200
      u-mb6 u-mb12--900
      u-ffs u-fws
      #{@props.css_utility_price}
    "

  getCopyAlignment: ->
    switch @props.copy_align
      when 'right' then 'u-tar--600'
      when 'left' then 'u-tal--600'
      else ''

  classesWillUpdate: ->
    block:
      "u-tac #{@getCopyAlignment()}": true
    link:
      'u-bc--blue--600 -blue': not @props.white_links
      'u-bc--white--600 u-color--white--600 -white': @props.white_links
      "#{@BLOCK_CLASS}__link": not @props.holiday_links
    title:
      'u-heading-md':
       not @props.headerOverride and
       not @props.two_up or @props.image_placement is 'fill'
      'u-heading-sm':
       not @props.headerOverride and
       @props.two_up and
       @props.image_placement isnt 'fill'

  downCaseAnd: (color = '') ->
    # TODO: Use Product Catalog as source of truth.
    newColor = color.replace(/\bAnd\b/g, 'and')
    newColor

  getSubtitle: ->
    if @props.product.subtitle
      @props.product.subtitle
    else
      @downCaseAnd(@props.product.color)

  renderPrice: (classes) ->
    price = @props.product.starting_price or @props.product.price_cents
    return false unless price and @props.show_price

    prefix = if @props.product.starting_price then 'Starting at $' else '$'
    if @props.price_unformatted
      <div children=price.product className=classes.price />
    else
      <div className=classes.price
        children="#{prefix}#{(price / 100).toFixed(2)}" />

  renderTitle: (classes) ->
    return false unless @props.product.display_name
    <h2 children=@props.product.display_name className=classes.title />

  renderSubtitle: (classes) ->
    return false unless @props.product.subtitle or @props.product.color
    <h3 children={@getSubtitle()} className=classes.subtitle />

  renderFrameDescription: (classes) ->
    return false unless @props.product.description and @props.show_description
    <Markdown
      rawMarkdown=@props.product.description
      className=classes.description
      cssBlock=classes.markdown />

  getLinkText: (gender) ->
    switch gender
      when 'm' then 'Shop Men'
      when 'f' then 'Shop Women'
      else 'Shop now'

  handleClick: (product) ->
    if _.isFunction @props.manageProductClick
      @props.manageProductClick(product)

  renderLink: (classes, product, key = '') ->
    <a
      href="/#{product.path or ''}"
      className=classes.link
      onClick={@handleClick.bind(@, product)}
      children={@getLinkText(product.gender)}
      key=key />

  mergeProduct: (data = {}) ->
    _.assign {}, @props.product, data

  renderLinks: (classes) ->
    return false unless @props.show_links
    genderedDetails = @props.product.gendered_details or []

    unless _.isEmpty genderedDetails
      genderedDetailWomens = _.find genderedDetails, gender: 'f'
      if @props.women_only and genderedDetailWomens
        # TODO: Remove incorrect male variants in Product Catalog.
        @renderLink classes, @mergeProduct(genderedDetailWomens)
      else
        _.map genderedDetails, (genderedDetail, i) =>
          @renderLink classes, @mergeProduct(genderedDetail), i
    else
      @renderLink classes, @props.product

  render: ->
    return false unless _.isObject @props.product

    classes = @getClasses()

    <div className=classes.block>
      { @renderPrice(classes) }
      { @renderTitle(classes) }
      { @renderSubtitle(classes) }
      { @renderFrameDescription(classes) }
      <div className=classes.links children={@renderLinks(classes)} />
    </div>
