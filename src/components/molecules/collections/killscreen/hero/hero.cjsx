[
  _
  React

  CTA
  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'

  require './hero.scss'

]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
  ]

  getDefaultProps: ->
    image: []
    logo: []
    copy: ''
    ctas: []

  propTypes:
    image: React.PropTypes.array
    logo: React.PropTypes.array
    copy: React.PropTypes.string
    ctas: React.PropTypes.array

  BLOCK_CLASS: 'c-killscreen-hero'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pr
      u-mb60
      u-mb120--600
      u-mb180--900
      u-mw2000
      u-mla u-mra
    "
    backgroundImage: '
      u-w100p
    '
    grid: '
      u-grid
      u-tac
    '
    row: '
      u-grid__row
      u-tar--900
    '
    column: '
      u-grid__col u-w11c u-w8c--600 u-w4c--900
      u-tac
    '
    contentWrapper: "
      #{@BLOCK_CLASS}__content-wrapper
      u-pa u-t0 u-center-y
    "
    copy: '
      u-reset
      u-fs16 u-fs18--600
      u-color--white
      u-lh26
      u-mb18 u-mb36--900
    '
    logo: "
      u-mb18 u-mb36--900
      #{@BLOCK_CLASS}__logo
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-mb12
    "
    ctaLeft: "
      #{@BLOCK_CLASS}__cta
      u-mb12
      u-mr12--600
    "

  getPictureAttrs: ->
    images = @props.image

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 1024, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 768, 1600, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 320, 1200, 200
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Killscreen Collection'
      className: @classes.backgroundImage

  getLogoAttrs: ->
    images = @props.logo

    sources: [
      url: @getImageBySize(images, 'desktop-sd')
      quality: @getQualityBySize(images, 'desktop-sd')
      widths: _.range 500, 900, 100
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(images, 'tablet')
      quality: @getQualityBySize(images, 'tablet')
      widths: _.range 300, 500, 100
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(images, 'mobile')
      quality: @getQualityBySize(images, 'mobile')
      widths: _.range 200, 600, 100
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: 'Killscreen Collection'
      className: @classes.logo

  handleCTAClick: (cta) ->
    ga = cta.ga or {}

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: 'CollectionKillscreen'
        id: ga.id
        name: ga.frame_name
        position: ga.position
        sku: ga.sku
        url: cta.href
      ]

  renderCTA: (cta, i) ->
    <CTA
      tagName='a'
      href=cta.href
      key=i
      children=cta.button_text
      analyticsSlug={_.get cta, 'ga.analytics_slug', ''}
      onClick={@handleCTAClick.bind @, cta}
      cssModifier={if i is 0 then @classes.ctaLeft else @classes.cta}
    />

  render: ->
    @classes = @getClasses()
    pictureAttrs = @getPictureAttrs()
    logoAttrs = @getLogoAttrs()

    <div className=@classes.block>
      <Picture children={@getPictureChildren(pictureAttrs)} />
      <div className=@classes.contentWrapper>
        <div className=@classes.grid>
          <div className=@classes.row>
            <div className=@classes.column>
              <Picture children={@getPictureChildren(logoAttrs)} />
              <p children=@props.copy className=@classes.copy />
              {
                if not @props.soldOut
                  _.map @props.ctas, @renderCTA
              }
            </div>
          </div>
        </div>
      </div>
    </div>
