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

  require './loader.scss'

]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  BLOCK_CLASS: 'c-killscreen-loader'

  getDefaultProps: ->

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
      u-pr
    "
    image: "
      #{@BLOCK_CLASS}__image
      u-w6c u-w2c--900 u-mla u-mra u-center-y u-pa
    "

  getLogoProps: ->
    url: 'https://i.warbycdn.com/v/c/assets/killscreen/image/modal/0/4158971579.jpg'
    widths: [400, 500, 600]

  logoSizes: [
    breakpoint: 0
    width: '100vw'
  ,
    breakpoint: 600
    width: '70vw'
  ]

  render: ->
    classes = @getClasses()
    logoSrc = @getSrcSet @getLogoProps()
    sizes = @getImgSizes @logoSizes

    <div className=classes.block>
      <Img srcSet=logoSrc sizes=sizes cssModifier=classes.image />
    </div>
