[
  _
  React

  CTA
  Img
  ResponsivePicture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/atoms/images/responsive_picture_v2/responsive_picture_v2'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  pictureSizes:
    xs: [
      break: 0
      image: 600
    ]
    s: [
      break: 600
      image: 900
    ]
    m: [
      break: 900
      image: 1200
    ]
    l: [
      break: 1200
      image: 1600
    ]

  propTypes:
    textPosition: React.PropTypes.string

  getDefaultProps: ->
    sizes: [
      breakpoint: 0
      width: 'calc(100vw - 36px)' # full viewport width - (2 * 18px grid padding)
    ,
      breakpoint: 396 # default grid max-width
      width: '360px' # 396px - 36px
    ,
      breakpoint: 600 # tablet grid breakpoint
      width: 'calc(((100vw - 48px) * 10 / 12) - 24px)'
        # full viewport width - ((2 * 36px grid) - (2 * 12px col) padding) *
        #   10 / 12 columns - (2 * 12 col padding)
    ,
      breakpoint: 732 # tablet grid max-width
      width: '546px' # ((732px - 48px) * 10 / 12) - 24px
    ,
      breakpoint: 900 # desktop grid breakpoint
      width: 'calc(((100vw - 60px) * 7 / 12) - 36px)'
        # full viewport width - ((2 * 48px grid) - (2 * 18px col) padding) *
        #   7 / 12 columns) - (2 * 18px col padding)
    ,
      breakpoint: 1056 # desktop grid max-width
      width: '545px' # ((1056px - 60px) * 7 / 12) - 36px
    ,
      breakpoint: 1200 # large desktop grid breakpoint
      width: 'calc(((100vw - 72px) * 7 / 12) - 48px)'
        # ((full viewport width - ((2 * 60px grid) - (2 * 24px row) padding)) *
        #   7 / 12 columns) - (2 * 24px col padding)
    ,
      breakpoint: 1440 # large desktop grid max-width
      width: '750px' # ((1440px - 72px) * 7 / 12) - 48px
    ]
    textPosition: 'right'
    widths: [320, 414, 640, 800, 1200, 1600]

  getStaticClasses: ->
    block: 'u-bss u-btw1 u-brw0 u-bbw1 u-blw0
      u-bc--light-gray
      u-pt48 u-pt60--600 u-pt84--900 u-pt96--1200
      u-pb48 u-pb60--600 u-pb84--900 u-pb96--1200'
    contents: 'u-clearfix
      u-w100p
      u-df--900 u-ai--c u-jc--sb
      u-m0a
      u-oh'
    image: 'u-db
      u-m0a u-mb24 u-mb0--900
      u-w12c u-w7c--900
      u-pr'
    details: 'u-w12c u-w5c--900
      u-pl18 u-pr18
      u-pr'
    label: 'u-m0
      u-ttu
      u-fws u-ffss u-fs12 u-ls2_5'
    title: 'u-mt0 u-mb0'
    cta: 'u-dib u-mt30
      u-fws u-ffss'
    collectionLogo: '
      u-w12c u-w6c--600 u-w10c--900
      u-mt10
    '

  classesWillUpdate: ->
    titleClasses = _.get(@props, 'text_styling.heading_font_class') or
      'u-fws u-ffs u-fs24 u-fs30--600 u-fs34--900 us-fs--1200'

    image:
      'u-ord0': @props.textPosition isnt 'left'
      'u-ord1': @props.textPosition is 'left'
    details:
      'u-ord0': @props.textPosition is 'left'
      'u-ord1': @props.textPosition isnt 'left'
      'u-pb12': @hasCta()
    title:
      "#{titleClasses}": true

  handleClick: (evt) ->
    @commandDispatcher 'analytics', 'pushPromoEvent',
      type: 'promotionClick'
      promos: @props

  hasCta: -> Boolean @props.link_text

  showCollectionLogo: ->
    Boolean @props.show_collection_logo

  logoSizes: [
    breakpoint: 0
    width: '80vw'
  ,
    breakpoint: 600
    width: '40vw'
  ,
    breakpoint: 900
    width: '30vw'
  ,
    breakpoint: 1440
    width: '450px'
  ]

  getLogoProps: ->
    url: @props.logo
    widths: _.range 200, 800, 100

  render: ->
    classes = @getClasses()

    <section className=classes.block>
      <div className=classes.contents>
        {if not _.isEmpty(@props.images)
          <div className=classes.image>
            <ResponsivePicture altText=@props.alt_text
              sizes=@pictureSizes
              sourceImages=@props.images />
          </div>
        else
          <Img alt=@props.alt_text
            cssModifier=classes.image
            sizes={@getImgSizes @props.sizes}
            srcSet={@getSrcSet(
              url: @props.image,
              widths: @props.widths
            )} />
        }
        <div className=classes.details>
          <div>
            <span className=classes.label children=@props.label />
            {
              if @showCollectionLogo()
                logoSrc = @getSrcSet @getLogoProps()
                sizes = @getImgSizes @logoSizes
                <Img srcSet=logoSrc
                     sizes=sizes
                     cssModifier=classes.collectionLogo />
              else
                <h1 className=classes.title children=@props.title />

            }
          </div>
          {if @hasCta()
            <CTA
              analyticsSlug="promo-click-#{_.camelCase @props.id}"
              tagName='a'
              href=@props.url_slug
              cssModifier=classes.cta
              cssUtility=''
              variation='secondary'
              onClick=@handleClick
              children=@props.link_text />}
        </div>
      </div>
    </section>
