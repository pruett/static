[
  _
  React

  RightArrow
  Hero
  PromoCallout
  CenterFrameCallout
  FullBleedFrameCallout
  CarouselCallout

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/molecules/landing/hero/hero'
  require 'components/molecules/landing/promo/promo'
  require 'components/molecules/landing/frame/center/center'
  require 'components/molecules/landing/frame/full/full'
  require 'components/molecules/landing/frame/carousel/carousel'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-curated'

  CALLOUT:
    PROMO: 'promo'
    CAROUSEL: 'carousel'
    CENTER: 'center'
    FULL: 'full'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.routing
  ]

  propTypes:
    callouts: React.PropTypes.array
    hero: React.PropTypes.object
    hide_page: React.PropTypes.bool

  getDefaultProps: ->
    callouts: []
    hero: {}
    hide_page: false

  buildGAImpressions: (callout, index) ->
    _.map callout.products, (product) ->
      impression =
        brand: product.brand or 'Warby Parker'
        category: product.class_key or 'Frame'
        gaPosition: index + 1
        id: product.product_id or product.id
        list: 'LandingPage_Curated'
        name: product.display_name

      impression.color = product.color if product.color
      impression.author = product.author if product.author
      impression

  componentDidMount: ->
    if @props.hide_page
      @navigateError()
    else
      @commandDispatcher 'analytics', 'pushPromoEvent',
        type: 'promotionImpression'
        promos: _.flatten _.map(@props.callouts, @buildGAImpressions)

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    callouts: '
      u-tac
      u-mw1440 u-mla u-mra u-mb u-mb96--900 u-mb120--1200
    '
    grid: '
      u-grid -maxed u-ma
      u-mt78--900 u-mt90--1200
    '
    row: '
      u-grid__row
    '
    hr: '
      u-bc--light-gray u-bw0 u-bbw1 u-bss
      u-mb48 u-mb60--600 u-mb84--900
    '

  getCalloutType: (callout = {}) ->
    # Get callout type based on props.
    switch callout.type
      when 'promo' then @CALLOUT.PROMO
      when 'frame'
        if callout.image_placement is 'top'
          if callout.show_swatches
            @CALLOUT.CAROUSEL
          else
            @CALLOUT.CENTER
        else if callout.image_placement is 'fill'
          @CALLOUT.FULL
      else null

  wrapComponentsByType: (classes, index, type) ->
    # Collect sequential callouts and wrap in grid.
    components = []
    for callout, i in @props.callouts.slice(index)
      break if @getCalloutType(callout) isnt type
      props = @getProps index + i

      if i is 0 and props.topBorder and not props.two_up
        # Separate with white-space above.
        components.push(
          <div className=classes.hrCol>
            <hr className=classes.hr key='hr' />
          </div>
        )

      components.push <CenterFrameCallout {...props} key=i />

    <section className=classes.grid key=index>
      <div className=classes.row children=components />
    </section>

  getEvent: (genderKey) ->
    # CMS data is keyed by a letter per gender, GA needs the full word.
    if genderKey is 'f' then 'clickShopWomen'
    if genderKey is 'm' then 'clickShopMen'
    else 'clickShop'

  manageProductClick: (product = {}) ->
    # Track WP event and replace any dashes.
    productSku = (product.sku or '').replace(/-/g,'')
    @trackInteraction "LandingPage-#{@getEvent(product.gender)}-#{productSku}"

    # Track custom GA ecommerce event.
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        id: product.product_id or product.id
        list: 'LandingPage_Curated'
        name: product.display_name
        sku: product.sku
        url: product.path
      ]

  getProps: (index) ->
    typePrev = @getCalloutType @props.callouts[index - 1]
    currProps = @props.callouts[index] or {}
    currProps.followsBleed = typePrev is @CALLOUT.FULL
    currProps.topBorder = not currProps.followsBleed and index isnt 0
    currProps.manageProductClick = @manageProductClick
    currProps

  reduceCalloutToComponent: (classes, components, callout, index, callouts) ->
    typeCurr = @getCalloutType callout
    typePrev = @getCalloutType callouts[index - 1]

    if typePrev is typeCurr and typeCurr is @CALLOUT.CENTER
      return components # Skip sequential callout types

    props = @getProps(index)
    components.concat(
      switch typeCurr
        when @CALLOUT.PROMO
          <PromoCallout {...props} key=index />

        when @CALLOUT.CAROUSEL
          <CarouselCallout
            {...props}
            columnModifier=1
            key=index
            gaPosition=index />

        when @CALLOUT.FULL
          <FullBleedFrameCallout {...props} key=index />

        when @CALLOUT.CENTER
          @wrapComponentsByType(classes, index, 'center')

        else false
    )

  render: ->
    return false if @props.hide_page

    classes = @getClasses()

    <div className=classes.block>
      <Hero {...@props.hero} />
      <section className=classes.calloutBlock>
        {@props.callouts.reduce @reduceCalloutToComponent.bind(@, classes), []}
      </section>
    </div>
