React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

Img = require 'components/atoms/images/img/img'

require './mosaic.scss'


module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-tyler-oakley-mosaic'

  propTypes:
    main_image: React.PropTypes.string
    right_image: React.PropTypes.string
    dots: React.PropTypes.string
    copy: React.PropTypes.string

  getDefaultProps: ->
    copy: ''
    main_image: ''
    right_image: ''
    dots: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-grid -maxed u-mla u-mra
      u-mt36 u-mt48--600 u-mtn36--900 u-mb48 u-mb72--900
    "
    columnMain: '
      u-grid__col u-w12c u-w6c--900
      u-tac u-tal--900
    '
    columnRight: "
      u-dn u-db--900 u-grid__col u-w6c
      #{@BLOCK_CLASS}__column-right
    "
    imageRight: '
      u-w12c
    '
    imageMain: '
      u-w12c
      u-mb36 u-mb24--900
    '
    copy: '
      u-tac u-tal--900
      u-ffs u-fs22
      u-color--black u-fws u-reset
      u-w10c--600 u-mla u-mra u-ml0--900
      u-mb36
    '
    dots: '
      u-w5c u-w3c--600
    '

  SIZES:
    main: [
      breakpoint: 0
      width: '80vw'
    ,
      breakpoint: 600
      width: '60vw'
    ,
      breakpoint: 900
      width: '40vw'
    ]
    right: [
      breakpoint: 900
      width: '50vw'
    ]
    dots: [
      breakpoint: 0
      width: '50vw'
    ,
      breakpoint: 900
      width: '30vw'
    ]

  getMainImageProps: ->
    url: @props.main_image
    widths: @getImageWidths 200, 1000, 8

  getRightImageProps: ->
    url: @props.right_image
    widths: @getImageWidths 800, 1200, 4

  getDotsProps: ->
    url: @props.dots
    widths: @getImageWidths 300, 600, 4

  render: ->
    classes = @getClasses()

    mainImageSrcSet = @getSrcSet @getMainImageProps()
    rightImageSrcSet = @getSrcSet @getRightImageProps()
    dotsSrcSet = @getSrcSet @getDotsProps()

    mainImageSizes = @getImgSizes @SIZES.main
    rightImageSizes = @getImgSizes @SIZES.right
    dotSizes = @getImgSizes @SIZES.dots


    <div className=classes.block>

      <div className=classes.columnMain>
        <Img srcSet=mainImageSrcSet sizes=mainImageSizes
             alt='Warby Parker and Tyler Oakley'
             cssModifier=classes.imageMain />
        <p children=@props.copy className=classes.copy />
        <Img srcSet=dotsSrcSet sizes=dotSizes
             alt='Warby Parker and Tyler Oakley'
             cssModifier=classes.dots />
      </div>

      <div className=classes.columnRight>
        <Img srcSet=rightImageSrcSet sizes=rightImageSizes
             alt='Warby Parker and Tyler Oakley'
             cssModifier=classes.imageRight />
      </div>

    </div>
