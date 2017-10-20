[
  _
  React

  Picture
  Img
  CopyBox
  Markdown

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'
  require 'components/atoms/images/img/img'
  require 'components/atoms/landing/copy/copy'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

]

module.exports = React.createClass

  BLOCK_CLASS: 'c-landing-curated-product-full'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.analytics
    Mixins.image
  ]

  getDefaultProps: ->
    manageProductClick: ->
    show_description: true
    text_align: 'right'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pr
      u-mla u-mra
      u-mw1440
      u-mb24 u-mb60--600 u-mb0--900
    "
    grid: '
      u-grid
      u-ma
      u-l0 u-r0
      u-tal--600
      u-t50p--600
      u-ttyn50--600
      u-pa--600
      u-w100p
    '
    row: '
      u-grid__row
    '
    picture: '
      u-w100p u-pr u-db u-h0
      u-pb1x1 u-pb3x2--600 u-pb2x1--900
      u-mb6 u-mb0--600
    '
    image: '
      u-w100p u-db
    '
    col: '
      u-grid__col
      u-w12c u-w5c--600
      u-pr
      u-mb48 u-mb0--600
      u-pt12 u-pt0--600
    '

  classesWillUpdate: ->
    col:
      'u-l7c--600': @props.text_align is 'right'

  getPictureAttrs: (classes) ->
    sources: [
      url: @getImageBySize(@props.image_overrides, 'm')
      quality: @getQualityBySize(@props.image_overrides, 'm')
      widths: _.range 1024, 2200, 200
      mediaQuery: '(min-width: 900px)'
    ,
      url: @getImageBySize(@props.image_overrides, 's')
      quality: @getQualityBySize(@props.image_overrides, 's')
      widths: _.range 768, 1600, 200
      mediaQuery: '(min-width: 600px)'
    ,
      url: @getImageBySize(@props.image_overrides, 'xs')
      quality: @getQualityBySize(@props.image_overrides, 'xs')
      widths: _.range 320, 1200, 200
      mediaQuery: '(min-width: 0px)'
    ]
    img:
      alt: _.get @props, 'product.display_name', ''
      className: classes.image

  render: ->
    classes = @getClasses()
    pictureAttrs = @getPictureAttrs classes

    <section className=classes.block>
      <Picture cssModifier=classes.picture
        children={@getPictureChildren(pictureAttrs)} />
      <div className=classes.grid>
        <div className=classes.row>
          <div className=classes.col>
            <CopyBox {...@props} />
          </div>
        </div>
      </div>
    </section>
