[
  _
  React

  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'
  require './float.scss'

]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial-callout-float'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getStaticClasses: ->
    block: '
      u-mb36 u-mb72--600 u-mb120--900
      u-grid -maxed
      u-mla u-mra
    '
    row: '
      u-grid__row
    '
    picture: '
      u-w100p
    '
    copyWrapper: '
      u-pt24 u-pt30--600 u-pt60--900
      u-tac
      u-dn u-db--600
    '
    copyWrapperMobile: '
      u-pt24 u-pt30--600 u-pt60--900
      u-tac
      u-dn--600
    '
    frame: '
      u-reset u-heading-md
      u-color--black
      u-mb10 u-mb12--600 u-mb18--900
      u-typekit--filson
      u-summer-2016__subheader
    '
    color: '
      u-reset
      u-fs16 u-fs18--600
      u-fsi
      u-color--dark-gray
      u-ffs
      u-mb10 u-mb12--600 u-mb18--900
    '
    shopLinks: '
      u-mt24 u-mt12--600
    '
    shopLinkLeft: "
      u-fs16 u-fs18--600
      u-pb6
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      u-mr24
      #{@BLOCK_CLASS}__shop-link
    "
    shopLinkRight: "
      u-fs16 u-fs18--600
      u-pb6
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      #{@BLOCK_CLASS}__shop-link
    "
    shopLinkWrapper: "
      #{@BLOCK_CLASS}__shop-link-wrapper
      u-mb24
      u-dib
    "

  getPictureAttrs: ->
    images = _.get @props, 'content.image'

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 1000, 2200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 800, 1200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 640px)'
    ,
      url: @getImageBySize(images, 'xs')
      quality: @getQualityBySize(images, 'xs')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Summer 2016 Editorial'
      className: @classes.picture

  classesWillUpdate: ->
    leftColumn:
      'u-grid__col u-w12c u-w7c--600 -col-middle': not @props.invert
      'u-grid__col u-w12c u-w5c--600 -col-middle': @props.invert
    rightColumn:
      'u-grid__col u-w12c u-w5c--600 -col-middle': not @props.invert
      'u-grid__col u-w12c u-w7c--600 -col-middle': @props.invert

  renderPicture: (picture) ->
    if @props.content.shoppable
      <a href=@props.content.image_href>
        <Picture children={@getPictureChildren(picture)} />
      </a>
    else
      <Picture children={@getPictureChildren(picture)} />

  renderColumn: (side) ->
    if side is 'left'
      unless @props.invert
        @renderPicture(@pictureAttrs)
      else
        @renderFrameCopy()
    else if side is 'right'
      if @props.invert
        @renderPicture(@pictureAttrs)
      else
        @renderFrameCopy()

  renderFrameCopy: ->
    <div className=@classes.copyWrapper>
      <h3 children=@props.content.copy.frame className=@classes.frame />
      <p children=@props.content.copy.color className=@classes.color />
      {
        if @props.content.shoppable
          @renderShopLinks()
      }
    </div>

  renderMobileFrameCopy: ->
    <div className=@classes.copyWrapperMobile>
      <h3 children=@props.content.copy.frame className=@classes.frame />
      <p children=@props.content.copy.color className=@classes.color />
      {
        if @props.content.shoppable
          @renderShopLinks()
      }
    </div>

  handleShopClick: (link) ->
    wpEvent = "LandingPage-clickShop#{link.ga_gender}-#{link.ga_sku}"
    @trackInteraction wpEvent

  renderShopLinks: ->
    multipleLinks = @props.content.shop_links.length > 1
    <div className=@classes.shopLinks>
      {
        _.map @props.content.shop_links, (link, i) =>
          <div key=i className=@classes.shopLinkWrapper>
            <a href=link.href
               onClick={@handleShopClick.bind @, link}
               children=link.text
               className={if i is 0 and multipleLinks then @classes.shopLinkLeft else @classes.shopLinkRight} />
          </div>
      }
    </div>

  render: ->
    @classes = @getClasses()
    @pictureAttrs = @getPictureAttrs()
    copy = _.get @props, 'content.copy', {}

    <section className=@classes.block>
      <div className=@classes.row>
        <div className=@classes.leftColumn>
          {
            @renderColumn('left')
          }
        </div>
        <div className=@classes.rightColumn>
          {
            @renderColumn('right')
          }
          {
            @renderMobileFrameCopy()
          }
        </div>
      </div>
    </section>
