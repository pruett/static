[
  _
  React

  CTA
  Img

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './frame_container.scss'

]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
  ]

  BLOCK_CLASS: 'c-killscreen-frame-container'

  getDefaultProps: ->
    ctas: []
    img: ''

  propTypes:
    ctas: React.PropTypes.array
    img: React.PropTypes.string

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mw1440
      u-mla u-mra
    "
    backgroundImage: '
      u-w100p
    '
    grid: '
      u-grid
    '
    row: '
      u-grid__row
      u-tac
    '
    column: '
      u-grid__col u-w12c u-w10c--600 u-w8c--900
      u-pr
    '
    cta: "
      #{@BLOCK_CLASS}__cta
      u-mb12
      u-button -button-white
    "
    ctaLeft: "
      #{@BLOCK_CLASS}__cta
      u-mb12
      u-mr6--600
      u-button -button-white
    "
    img: '
      u-mb48 u-mb72--600
    '
    soldOut: '
      u-fs16 u-fs24--900
      u-mtn24 u-mtn36--600
    '

  classesWillUpdate: ->
    block:
      'u-mb72 u-mb120--600 u-mb180--900': not @props.soldOut
      'u-mb36 u-mb60--600 u-mb120--900': @props.soldOut

  frameSizes: [
    breakpoint: 0
    width: '100vw'
  ,
    breakpoint: 600
    width: '80vw'
  ,
    breakpoint: 900
    width: '70vw'
  ]

  getImgProps: ->
    url: @props.img
    widths: _.range 200, 1000, 100

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

  renderCTAs: ->
    <div className=@classes.ctaWrapper>
      {_.map @props.ctas, @renderCTA}
    </div>

  render: ->
    @classes = @getClasses()
    imgSrc = @getSrcSet @getImgProps()
    sizes = @getImgSizes @sizes

    <div className=@classes.block>
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.column>
            <Img srcSet=imgSrc sizes=sizes cssModifier=@classes.img />
            {
              if @props.soldOut
                <h2 className=@classes.soldOut children="Sold Out" />
            }
            {
              if not @props.soldOut
                @renderCTAs()
            }
          </div>
        </div>
      </div>
    </div>
