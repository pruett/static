[
  _
  React

  CopyBox
  Picture
  Img
  Markdown

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/landing/copy/copy'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-curated-product-center'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
    Mixins.image
  ]

  getDefaultProps: ->
    product: {}
    manageProductClick: ->
    show_description: false
    two_up: false
    women_only: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-grid__col -col-middle
      u-mb24"
    picture: '
      u-db
    '
    image: "
      u-mb18 u-mb24--600
      u-mla u-mra
      u-w100p
      u-db
    "
    row: '
      u-grid__row
    '
    col: '
      u-grid__col u-w12c
      u-mb48 u-mb60--600 u-mb78--900 u-mb90--1200
      u-pt12
      u-tac
    '

  classesWillUpdate: ->
    block:
      'u-w6c': @props.two_up and @props.two_up_mobile
      'u-w12c u-w6c--600
      u-pr u-l0--600': @props.two_up and not @props.two_up_mobile
      'u-w12c u-w8c--600
      u-pr u-l2c--600': not @props.two_up
    hr:
      'u-dn--600': @props.followsBleed
    image:
      'u-mb36--1200': @props.two_up
      'u-mb54--600 u-mb66--1200': not @props.two_up
    col:
      'u-w8c--600 u-pr u-l2c--600 u-p60--900': not @props.two_up
      'u-pt24--600': @props.two_up

  getImgProps: ->
    url: @props.product.image or _.get(@props, 'product.images.front')
    widths: [200, 300, 400, 500, 600, 700, 800, 900]

  imgSizes: ->
    divisorMobile = if @props.two_up_mobile then 2 else 1
    divisorTablet = if @props.two_up then 2 else 1
    [
      breakpoint: 0,
      width: "#{80 / divisorMobile}vw"
    ,
      breakpoint: 600,
      width: "#{80 / divisorTablet}vw"
    ,
      breakpoint: 900,
      width: "#{80 / divisorTablet}vw"
    ]

  getPictureAttrs: (classes) ->
    divisorMobile = if @props.two_up_mobile then 1 else 2
    divisorTablet = if @props.two_up then 1 else 2

    sources: [
      url: @getImageBySize(@props.image_overrides, 'm')
      quality: @getQualityBySize(@props.image_overrides, 'm')
      widths: _.range(1024 / divisorMobile, 2200 / divisorMobile, 200)
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(@props.image_overrides, 's')
      quality: @getQualityBySize(@props.image_overrides, 's')
      widths: _.range(768 / divisorTablet, 1600 / divisorTablet, 200)
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(@props.image_overrides, 'xs')
      quality: @getQualityBySize(@props.image_overrides, 'xs')
      widths: _.range(320 / divisorTablet, 1200 / divisorTablet, 200)
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: _.get @props, 'product.display_name', ''
      className: classes.image

  renderImage: (classes) ->
    # Allow overriding of image.
    if _.get @props, 'image_overrides[0].image'
      <Picture cssModifier=classes.picture
        children={@getPictureChildren(@getPictureAttrs(classes))} />
    else
      <Img cssModifier=classes.image
        srcSet={@getSrcSet(@getImgProps())}
        sizes={@getImgSizes(@imgSizes())} />

  handleClick: (product) ->
    if _.isFunction @props.manageProductClick
      @props.manageProductClick(product)

  renderLink: (classes, product) ->
    <a href="/#{product.path or ''}"
      onClick={@handleClick.bind(@, product)}
      children={@renderImage(classes)} />

  mergeProduct: (data = {}) ->
    _.assign {}, @props.product, data

  getImagery: (classes) ->
    genderedDetails  = _.get @props, 'product.gendered_details', []
    genderedDetailsSize = _.size genderedDetails

    if genderedDetailsSize is 0
      @renderLink classes, @props.product
    else if genderedDetailsSize is 1
      @renderLink classes, @mergeProduct(genderedDetails[0])
    else
      genderedDetailWomens = _.find genderedDetails, gender: 'f'
      if @props.women_only and genderedDetailWomens
        # TODO: Remove incorrect male variants in Product Catalog.
        @renderLink classes, @mergeProduct(genderedDetailWomens)
      else
        @renderImage(classes)

  render: ->
    classes = @getClasses()

    <div className=classes.block>

      {@getImagery(classes)}

      <div className=classes.row>
        <div className=classes.col>
          <CopyBox {...@props} />
        </div>
      </div>

    </div>
