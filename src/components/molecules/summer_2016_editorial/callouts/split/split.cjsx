[
  _
  React

  Img
  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './split.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial-callout-split'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getStaticClasses: ->
    block: '
      u-grid -maxed
      u-mb24 u-mb72--600 u-mb120--900
      u-mla u-mra
    '
    row: '
      u-grid__row
    '
    leftColumn: '
      u-grid__col u-w12c -c-6--600
    '
    rightColumn: '
      u-grid__col u-w12c -c-6--600
    '
    copyWrapper: '
      u-tac
      u-pt24 u-pt84--900
      u-mbn12 u-mbn0--600
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
      u-mb12--600 u-mb18--900
    '
    img: '
      u-w100p
    '
    picture: '
      u-w100p--600
    '
    shopLinkLeft: "
      u-fs16 u-fs18--600
      u-pb6
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      u-mr24 u-mr0--600
      #{@BLOCK_CLASS}__shop-link
    "
    shopLinkRight: "
      u-fs16 u-fs18--600
      u-pb6
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      #{@BLOCK_CLASS}__shop-link
    "
    shopLinks: '
      u-mt24 u-mt0--600
    '
    shopLinkWrapperTop: "
      #{@BLOCK_CLASS}__shop-link-wrapper
      u-mb36 u-mb24--600
      u-dib
    "
    shopLinkWrapperBottom: "
      #{@BLOCK_CLASS}__shop-link-wrapper
      u-mb0 u-mb24--600
      u-dib
    "

  classesWillUpdate: ->
    rightColumn:
      'u-pt36--600 u-pt72--900 u-mb12': @props.invert and not @props.content.shoppable
      'u-pt18--600 u-p736--900 u-mb12': @props.invert and @props.content.shoppable
    leftColumn:
      'u-pt36--600 u-pt72--900 u-mb12': not @props.invert and not @props.content.shoppable
      'u-pt18--600 u-p736--900 u-mb12': not @props.invert and @props.content.shoppable


  getBigPictureAttrs: ->
    images = _.get @props, 'content.big_image'

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 1200, 2200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 600, 1200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 600px)'
    ]
    img:
      alt: 'Summer 2016 Editorial'
      className: @classes.picture


  getSmallPictureAttrs: ->
    images = _.get @props, 'content.small_image'

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 900, 2200, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 700, 1400, 200
      sizes: '60vw'
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'xs')
      quality: @getQualityBySize(images, 'xs')
      widths: _.range 300, 700, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Summer 2016 Editorial'
      className: @classes.img

  renderLeftColumn: ->
    unless @props.invert #  Default, highlight image on left
      <div>
        { @renderPicture(@smallPictureAttrs) }
        { @renderFrameCopy() }
      </div>
    else
      @renderPicture(@bigPictureAttrs)

  renderRightColumn: ->
    unless @props.invert #  Default, lifestyle image on right
      @renderPicture(@bigPictureAttrs)
    else
      <div>
        { @renderPicture(@smallPictureAttrs) }
        { @renderFrameCopy() }
      </div>

  renderPicture: (picture) ->
    if @props.content.shoppable
      <a href=@props.content.image_href>
        <Picture children={@getPictureChildren(picture)} />
      </a>
    else
      <Picture children={@getPictureChildren(picture)} />

  renderFrameCopy: ->
    <div className=@classes.copyWrapper>
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
          <div key=i className={if i is 0 then @classes.shopLinkWrapperTop else @classes.shopLinkWrapperBottom}>
            <a href=link.href
               children=link.text
               onClick={@handleShopClick.bind @, link}
               className={if i is 0 and multipleLinks then @classes.shopLinkLeft else @classes.shopLinkRight} />
          </div>
      }
    </div>

  render: ->
    @classes = @getClasses()
    @bigPictureAttrs = @getBigPictureAttrs()
    @smallPictureAttrs = @getSmallPictureAttrs()

    <section className=@classes.block>
      <div className=@classes.row>
        <div className=@classes.leftColumn>
          { @renderLeftColumn() }
        </div>
        <div className=@classes.rightColumn>
          { @renderRightColumn() }
        </div>
      </div>
    </section>
