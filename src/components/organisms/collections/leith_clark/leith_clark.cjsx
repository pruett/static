React = require 'react/addons'
_ = require 'lodash'

TypeKit = require 'components/atoms/scripts/typekit/typekit'

Picture = require 'components/atoms/images/picture/picture'

Mixins = require 'components/mixins/mixins'

Hero = require 'components/molecules/collections/leith_clark/hero/hero'

Frame = require 'components/molecules/collections/leith_clark/frame/frame'

Callout = require 'components/molecules/collections/leith_clark/callout/callout'

require './leith_clark.scss'

module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
    Mixins.classes
    Mixins.context
  ]

  BLOCK_CLASS: 'c-leith-clark'

  TYPEKIT_ID: 'iec5uux'

  propTypes:
    content: React.PropTypes.object

  getDefaultProps: ->
    content: {}

  componentDidMount: ->
    @dispatchProductImpressions()

  getRegionalProducts: ->
    products = _.compact(_.clone(_.get @props, '__data.products'))

    if @isCanada
      products = _.omit products, 'b'

    products

  dispatchProductImpressions: ->
    products = @getRegionalProducts()

    impressions = @assembleProductImpressions(products)

    unless _.isEmpty impressions
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: impressions

  assembleProductImpressions: (products) ->
    productsArray = []

    # a counter to report product position to GA
    gaPosition = 1

    for id, product of products
      baseImpression =
        brand: 'Warby Parker'
        category: 'Frame'
        list: 'Collection-LeithClark'

      impression = _.assign baseImpression,
        color: product.color
        name: product.display_name
        position: gaPosition
        id: product.product_id

      gaPosition++

      productsArray.push impression

    productsArray

  injectFrames: (frameIds=[]) ->
    # a method that takes product ids and returns their JSON from @props._data
    frameData = _.get @props, '__data.products', {}
    _.compact (
      _.map frameIds, (id) ->
        return frameData["#{id}"]
    )

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw1440
      u-mla u-mra
    "
    image: '
      u-w100p
    '
    lifestyleWrapper: '
      u-mb48 u-mb72--600 u-mb96--900
      u-pr
    '
    gridLabel: '
      u-grid -maxed
      u-pa u-l0 u-b0 u-pb18
      u-w100p
      c-leith-clark-label-right
    '
    row: '
      u-grid__row
    '
    column: '
      u-grid__col
    '
    labelName: '
      u-fs16 u-color--white
      u-ffs u-fwb
    '
    labelColor: '
      u-ffs u-fsi
      u-fs16 u-color--white
    '
    doGoodCalloutMobile: '
      u-dn--600
    '
    doGoodCalloutDesktop: '
      u-dn u-db--600
    '
    labelModifierRight: '
      u-tal u-tar--600
    '

  isCanada: ->
    @getLocale().country is 'CA'

  getPictureAttrs: (section) ->
    images = section.image

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 900, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1400, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker x Leith Clark'
      className: @classes.image

  getLabelOrientation: (orientation) ->
    "u-grid__row #{orientation}"

  renderLifestylePhoto: (section, labelOrientation) ->
    pictureAttrs = @getPictureAttrs(section)
    label = _.get section, 'label', {}
    <div className=@classes.lifestyleWrapper >
      <Picture children={@getPictureChildren(pictureAttrs)} />
      <div className={@getLabelOrientation(labelOrientation)}>
        <div className=@classes.gridLabel>
          <div className=@classes.column>
            <span children=label.name className=@classes.labelName />
            <span children=label.color className=@classes.labelColor />
          </div>
        </div>
      </div>
    </div>

  render: ->
    @classes = @getClasses()

    isCanada = @isCanada()

    detailCallout = @props.detail_callout or {}
    doGoodCallout = @props.dogood_callout or {}
    zeldaLifestyle = @props.zelda_hero or {}
    valdaLifestyle = @props.valda_hero or {}
    liliaLifestyle = @props.lilia_hero or {}
    liliaLifestyleSun = @props.lilia_hero_sun or {}
    framesRows = @props.frames_rows or {}

    <div className=@classes.block>
      <TypeKit typeKitModifier=@TYPEKIT_ID />

      <Hero {...@props.hero} />

      <Frame frames={@injectFrames(framesRows.first)} startingPosition=1 twoUp=false />

      <Callout {...detailCallout} />

      {@renderLifestylePhoto(zeldaLifestyle, @classes.labelModifierRight)}

      <Frame frames={@injectFrames(framesRows.second)} startingPosition=2 twoUp=true />

      {@renderLifestylePhoto(valdaLifestyle, 'u-tal')}

      <Frame frames={@injectFrames(framesRows.third)} startingPosition=4 twoUp=true />

      <div className=@classes.doGoodCalloutDesktop>
        <Callout {...doGoodCallout} second=true />
      </div>

      <Frame frames={@injectFrames(framesRows.fourth)} startingPosition=6 twoUp=true />

      <div className=@classes.doGoodCalloutMobile>
        <Callout {...doGoodCallout} second=true />
      </div>
      {
        # Lilia frame in Optical is not being sold in Canada
        if isCanada
          <div>
            {@renderLifestylePhoto(liliaLifestyleSun, @classes.labelModifierRight)}
            <Frame frames={@injectFrames(framesRows.fifthCA)} startingPosition=10 twoUp=true />
          </div>
        else
          <div>
            {@renderLifestylePhoto(liliaLifestyle, @classes.labelModifierRight)}
            <Frame frames={@injectFrames(framesRows.fifthUS)} startingPosition=11 twoUp=true />
          </div>
      }
    </div>
