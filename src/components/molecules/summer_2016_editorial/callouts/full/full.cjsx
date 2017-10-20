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

  require './full.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial-callout-full'

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.analytics
  ]

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
    '
    grid: '
      u-grid
    '
    row: '
      u-grid__row
      u-tac
    '
    picture: '
      u-w100p
    '
    copyWrapper: '
      u-grid__col u-w12c -c-7--600
      u-pt24
      u-pb72--600
      u-pt48--900 u-pb84--900
    '
    frame: '
      u-reset u-heading-md
      u-color--black
      u-mb12 u-mb18--900
      u-typekit--filson
      u-summer-2016__subheader
    '
    color: '
      u-reset
      u-fs16 u-fs18--600
      u-fsi
      u-color--dark-gray
      u-ffs
      u-mb12 u-mb18--600
    '
    description: '
      u-reset
      u-summer-2016__body
    '
    shopLinks: '
      u-mt24 u-mt12--600 u-mt24--900
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
    copyWrapper:
      'u-pb24 u-pb60--600': @props.firstCallout
      'u-pb24': not @props.firstCallout

  getPictureAttrs: ->
    images = _.get @props, 'content.image'

    sources: [
      url: @getImageBySize(images, 'm')
      quality: @getQualityBySize(images, 'm')
      widths: _.range 1000, 2200, 200
      mediaQuery: '(min-width: 960px)'
    ,
      url: @getImageBySize(images, 's')
      quality: @getQualityBySize(images, 's')
      widths: _.range 700, 1400, 200
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

  renderPicture: (picture) ->
    if @props.content.shoppable
      <a href=@props.content.image_href>
        <Picture children={@getPictureChildren(picture)} />
      </a>
    else
      <Picture children={@getPictureChildren(picture)} />

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
    @pictureAttrs = @getPictureAttrs()
    copy = _.get @props, 'content.copy', {}

    <section className=@classes.block>
      { @renderPicture(@pictureAttrs) }
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.copyWrapper>
            <h3 children=copy.frame className=@classes.frame />
            <h4 children=copy.color className=@classes.color />
            <p children=copy.description className=@classes.description />
            {
              if @props.content.shoppable
                @renderShopLinks()
            }
          </div>
        </div>
      </div>
    </section>
