[
  _
  React

  RightArrow
  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './list_frame.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-list-frame'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
  ]

  getDefaultProps: ->
    analyticsCategory: 'frameList'
    cssModifier: ''
    htoMode: false
    product: {}
    widths: [104, 208, 280, 560]
    sizes: [
      breakpoint: 0
      width: '104px'
    ,
      breakpoint: 600
      width: '280px'
    ]
    handleProductClick: ->

  shouldComponentUpdate: ->
    false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-grid__col u-w12c -c-4--600 -c-3--900
    "
    row: '
      u-grid__row
      u-tac--600
    '
    image_container: '
      u-grid__col -c-4 -c-12--600
    '
    image: "
      #{@BLOCK_CLASS}__image
    "
    details: '
      u-grid__col -c-6 -c-12--600
    '
    name: '
      u-reset u-fs18 u-ffs u-fws
      u-color--dark-gray
    '
    color: '
      u-reset u-fs16 u-ffs u-fsi u-ttc
      u-color--dark-gray-alt-2
    '
    divider: "
      #{@BLOCK_CLASS}__divider
      u-grid__col u-w12c
    "
    arrow: "
      #{@BLOCK_CLASS}__arrow
    "

  classesWillUpdate: ->
    block:
      '-disabled': @props.htoMode and not @props.product.hto_available

  render: ->
    classes = @getClasses()
    product = @props.product

    <a className=classes.block
      href="/#{product.path}"
      onClick=@props.handleProductClick>
      <div className=classes.row>
        <div className=classes.image_container>
          <Img
            cssModifier=classes.image
            alt="#{product.display_name} in #{product.color}"
            srcSet={@getSrcSet url: product.image, widths: @props.widths}
            sizes={@getImgSizes @props.sizes} />
        </div>
        <div className=classes.details>
          <h3 className=classes.name children=@props.product.display_name />
          <span className=classes.color children=@props.product.color />
        </div>
        <div className=classes.divider>
          <hr className='u-hr -no-margin' />
        </div>
      </div>
      <RightArrow cssModifier=classes.arrow />
    </a>
