
[
  _
  React

  RightArrow

  TypeKit
  Picture
  Img
  Markdown
  FramesGrid
  LayoutDefault

  FrameHandlingMixin
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/atoms/scripts/typekit/typekit'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/landing/frames_grid/frames_grid'
  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/collections/frame_handling_mixin'
  require 'components/mixins/mixins'

  require './gallery.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-collections-summer-2016-gallery'

  mixins: [
    Mixins.classes
    Mixins.image
    FrameHandlingMixin
    Mixins.context
    Mixins.dispatcher
    Mixins.analytics
  ]

  TYPEKIT_ID: 'zzq0ivh'

  GA_LIST_MODIFIER: 'Summer2016'

  componentDidMount: ->
    unless @props.version is 'fans'
      @getVersionedImpressions(@frames, @props.version, 'f')
    else
      @getFansImpressions(@frames)

  getDefaultProps: ->
    frameType: 'sun'
    version: 'fans'
    gaListModifier: 'Collection-Summer2016'

  getStaticClasses: ->
    block: @BLOCK_CLASS
    heroWrapper: '
      u-pr
      u-mla u-mra
      u-mw1440
      u-mb60 u-mb48--600 u-mb140--900
    '
    heroBackground: "
      #{@BLOCK_CLASS}__hero-background
      u-w100p
    "
    copy: '
      u-reset
    '
    logo: "
      #{@BLOCK_CLASS}__logo
    "
    grid: '
      u-grid -maxed u-mla u-mra
    '
    heroRow: '
      u-grid__row
    '
    row: '
      u-grid__row
      u-tac u-tal--1200
    '
    rowPricing: '
      u-grid__row
      u-tac
    '
    htoCopyWrapper: '
      u-grid__col u-w12c -c-10--600 -c-6--900
      u-pb60  u-pb72--900
      u-pt24 u-pt0--900 u-mtn36--900
    '
    htoHeader: "
      u-reset
      #{@BLOCK_CLASS}__hto-header
      u-mb12 u-mb24--900
    "
    htoBody: '
      u-reset
      u-body-standard
      u-mb12 u-mb36--900
    '
    htoLink: '
      u-fs16 u-fs18--900
    '
    priceWrapper: '
      u-grid__col u-w12c -c-6--600
      u-mb24 u-mb96--1200
      u-mt72--1200
    '
    priceText: '
      u-fs18 u-color--black
      u-mb36 u-mt18
      u-fwb
    '
    heroHeader: "
      #{@BLOCK_CLASS}__hero-header
      u-color--black
      u-typekit--filson
      u-fs30 u-fs40--600
      u-ls2
      u-reset
    "
    heroColumn: '
      u-tac
      u-grid__col u-w11c u-w10c--600 u-w4c--1200
    '
    heroCopy: '
      u-reset
      u-body-standard
      u-mb24
    '
    heroCopyWrapper: "
      #{@BLOCK_CLASS}__hero-copy-wrapper
      u-color-bg--white--900
      u-pl36--900 u-pr36--900
      u-pt8--900
      u-pb60--900
    "
    heroLink: "
      u-fs16 u-fs18--600
      u-pb8
      u-fws
      u-bbss u-bbw2 u-bbw0--900 u-bc--blue
      #{@BLOCK_CLASS}__hero-link
    "
    heroGrid: '
      u-grid
      u-pa--1200 u-center--1200 u-w100p
      u-mw1440
    '
    rowHTO: '
      u-grid__row
      u-tac
    '
    gridHTO: '
      u-grid -maxed u-mla u-mra
    '
    galleryLinksWrapper: '
      u-grid__row u-tac
      u-mb36 u-mb0--600 u-mb24--900
      u-mtn48--900 u-pt60 u-pt36--600 u-pt60--900
      u-btw1 u-btss u-bc--light-gray
    '
    galleryLinkWrapper: '
      u-grid__col u-w12c u-w6c--600 u-w12c--900
      u-mb36 u-mb--600 u-mb48--900
    '
    galleryLink: "
      #{@BLOCK_CLASS}__gallery-link
    "
    rightArrow: "
      #{@BLOCK_CLASS}__right-arrow
    "

  getBorderColor: ->
    switch @props.version
      when 'fans' then 'blue'
      when 'men' then 'orange'
      else 'pink'

  classesWillUpdate: ->
    centerHeroText = @props.version is 'fans' and @props.frameType is 'sun'
    color = @getBorderColor()
    heroBackground:
      "-#{color}": true
    heroCopyWrapper:
      "-#{color}": true
    heroColumn:
      'u-pr u-l8c--1200': @props.frameType is 'optical'
    heroRow:
      'u-tac u-tal--1200': not centerHeroText
      'u-tac': centerHeroText
    heroHeader:
      'u-mb36 u-mt48': @props.frameType is 'optical'
      'u-mb8 u-mt18 u-mb36--900 u-mt48-900': @props.frameType is 'sun'

  getPictureAttrs: (heroImages) ->
    sources: [
      url: @getImageBySize(heroImages, 'm')
      quality: @getQualityBySize(heroImages, 'm')
      widths: _.range 1024, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(heroImages, 's')
      quality: @getQualityBySize(heroImages, 's')
      widths: _.range 600, 1600, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(heroImages, 'xs')
      quality: @getQualityBySize(heroImages, 'xs')
      widths: _.range 320, 900, 200
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Windsor Spring collection'
      className: @classes.heroBackground

  getLogoProps: (logoURL) ->
    url: logoURL
    widths: [200, 250, 300, 350, 400]

  renderGalleryLinks: ->
    links = _.get @props, "content.#{@props.frameType}.gallery_links.#{@props.version}", []
    <div className=@classes.grid>
      <div className=@classes.galleryLinksWrapper>
        {
          _.map links, @renderGalleryLink
        }
      </div>
    </div>

  handleGalleryClick: (link) ->
    @trackInteraction "LandingPage-clickLink-#{link.ga_slug}"

  renderGalleryLink: (link, i) ->
    <div className=@classes.galleryLinkWrapper key=i>
      <a href=link.href
         children=link.text
         onClick={@handleGalleryClick.bind @, link}
         className=@classes.galleryLink>
        <span children=link.text /> <RightArrow cssModifier=@classes.rightArrow />
      </a>
    </div>

  renderHero: ->
    heroData = _.get @props, "content.#{@props.frameType}.hero.#{@props.version}", {}
    pictureAttrs = @getPictureAttrs(heroData.images)
    logoSrcSet = @getSrcSet @getLogoProps(heroData.logo)

    <div className=@classes.heroWrapper>
      <Picture children={@getPictureChildren(pictureAttrs)} />
      <div className=@classes.heroGrid>
        <div className=@classes.heroRow>
          <div className=@classes.heroColumn>
            <div className=@classes.heroCopyWrapper>
              <h2 children=heroData.header className=@classes.heroHeader />
              <Markdown rawMarkdown={@getRegionalPricing()} className=@classes.priceText cssBlock=@classes.copy />
              <p children=heroData.body className=@classes.heroCopy />
              <a
                href=heroData.link.href
                children=heroData.link.copy
                onClick=@handleHeroClick
                className=@classes.heroLink />
            </div>
          </div>
        </div>
      </div>
    </div>

  renderHTO: ->
    hto = _.get @props, 'content.hto', {}
    <div className=@classes.gridHTO>
      <div className=@classes.rowHTO>
        <div className=@classes.htoCopyWrapper>
          <h2 children=hto.header className=@classes.htoHeader />
          <p children=hto.body className=@classes.htoBody />
        </div>
      </div>
    </div>

  getRegionalPricing: ->
    locale = @getLocale('country')
    _.get @props, "content.#{@props.frameType}.pricing_text[#{locale}]"

  handleHeroClick: ->
    @trackInteraction 'LandingPage-clickLink-SeeHowWeSummer'

  useTextColors: ->
    # We only want to show color swatches in the Fans Sun galleries
    # Always show swatches in ALL optical galleries
    @props.frameType is 'sun' and @props.version isnt 'fans'

  render: ->
    @classes = @getClasses()
    @frames = _.get @props, "content.#{@props.frameType}.frames.#{@props.version}"
    locale = @getLocale('country')

    <section className=@classes.block>
      <TypeKit typeKitModifier=@TYPEKIT_ID />
      { @renderHero() }
      <FramesGrid
        gaListModifier=@GA_LIST_MODIFIER
        frames=@frames
        version=@props.version
        defaultPosition=1
        useTextColors={@useTextColors()}
        columnModifier=2 />
      {
        if @props.frameType is 'optical' and locale is 'US'
          @renderHTO()
      }
      { @renderGalleryLinks() }
    </section>
