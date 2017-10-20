React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

Img = require 'components/atoms/images/img/img'
Picture = require 'components/atoms/images/picture/picture'



module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  propTypes:
    left: React.PropTypes.object
    right: React.PropTypes.object
    gaPosition: React.PropTypes.number

  getDefaultProps: ->
    gaPosition: 0
    left: {}
    right: {}

  BLOCK_CLASS: 'c-winter-2016-callout'

  getPictureAttrs: (callout, side) ->
    images = callout.image

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 900, 2201, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 700, 1401, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 300, 701, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Warby Parker Winter 2016'
      className: if side is 'left' then @classes.leftImage else @classes.image

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
      u-pr
      u-mb18 u-mb36--900
      u-mt48--600 u-mtn36--900
      u-mb120--1200
    '
    image: '
      u-w12c
    '
    leftImage: '
      u-w12c
    '
    frameName: '
      u-fs22 u-fs24--900
      u-color-winter-2016--blue
      u-ffs u-fws
    '
    frameColor: '
      u-fs22 u-fs24--900
      u-color-winter-2016--blue
      u-ffs u-fsi
    '
    calloutWrapper: '
      u-w12c u-w6c--600
      u-dib
      u-mb24
    '
    calloutWrapperLeft: '
      u-w12c u-w6c--600
      u-dib
      u-pt48 u-pt0--600
      u-mb24--600
    '
    frameInfoWrapper: '
      u-tac
      u-mb24
    '
    link: '
      c-winter-2016-link
      u-fws u-fs16 u-fs18--900 u-wsnw
    '
    linkLeft: '
      c-winter-2016-link
      u-fws u-fs16 u-fs18--900 u-wsnw
      u-mr24
    '
    singleCTAWrapper: '
      u-tac
    '

  classesWillUpdate: ->
    calloutWrapperLeft:
      'u-mb60': @props.dual_ctas
    calloutWrapper:
      'u-mtn6 u-mtn0--600': not @props.dual_ctas
    image:
      'u-mb24': @props.dual_ctas
    leftImage:
      'u-mb24': not @props.dual_ctas

  renderSide: (calloutData, side) ->
    pictureAttrs = @getPictureAttrs(calloutData)
    frameData = calloutData.frame_data or {}
    <div className={if side is 'left' then @classes.calloutWrapperLeft else @classes.calloutWrapper}>
      <Picture children={@getPictureChildren(pictureAttrs, side)} />
      {
        if @props.dual_ctas
          <div>
            <p className=@classes.frameInfoWrapper>
              <span children=frameData.display_name className=@classes.frameName />
              <span children={" in #{frameData.color} "} className=@classes.frameColor />
            </p>
            <div className=@classes.singleCTAWrapper>
              {
                if @props.version is 'fans'
                  (frameData.gendered_details or []).map (link, i) =>
                    @renderFansLinks(link, calloutData, i)
                else
                  @renderGenderedLink(frameData.gendered_details, calloutData)
              }
            </div>
          </div>
      }
    </div>

  handleShopLinkClick: (link, calloutData) ->
    frameData = calloutData.frame_data or {}

    #  Manipulate gender string to match variable expected in GA
    genderLookUp =
      m: 'Men'
      f: 'Women'

    gaProductClickData =
      brand: 'Warby Parker'
      category: 'Eyeglasses'
      id: link.product_id
      name: frameData.display_name
      position: calloutData.ga_position
      sku: frameData.sku
      url: frameData.path

    @trackInteraction("LandingPage-clickShop#{genderLookUp[link.gender]}-#{frameData.sku}")
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [gaProductClickData]

  renderGenderedLink: (genderedDetails={}, calloutData ) ->
    details = _.find genderedDetails, gender: @props.version
    return false unless details

    <a
      href={"/#{details.path}"}
      className=@classes.link
      onClick={@handleShopLinkClick.bind @, details, calloutData}
      children='Shop now' />

  renderFansLinks: (link, calloutData, i) ->
    # Workaround to avoid displaying links for non-existent PDPs
    return false if link.gender is 'm' and calloutData.women_only

    <a
      className={if i is 0 then @classes.linkLeft else @classes.link}
      onClick={@handleShopLinkClick.bind @, link, calloutData}
      key=i
      href=link.path
      children={if link.gender is 'm' then 'Shop Men' else 'Shop Women'} />

  renderSingleCta: (frameProps) ->
    frameData = frameProps.frame_data or {}
    <div className=@classes.singleCTAWrapper>
      <p className=@classes.frameInfoWrapper>
        <span children=frameData.display_name className=@classes.frameName />
        <span children=' in ' className=@classes.frameColor />
        <span children=frameData.color className=@classes.frameColor />
      </p>
      {
        if @props.version is 'fans'
          frameData.gendered_details.map (link, i) =>
            @renderFansLinks(link,frameProps, i)
        else
          @renderGenderedLink(frameData.gendered_details, frameProps)
      }
    </div>


  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      {@renderSide(@props.left, 'left')}
      {@renderSide(@props.right, 'right')}
      {
        if not @props.dual_ctas
          @renderSingleCta(@props.right)
      }
    </div>
