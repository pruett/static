[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.image
  ]

  getDefaultProps: ->
    image: ''
    altText: ''
    cssModifier: ''
    sizes: [
      breakpoint: 0
      width: 'calc(100vw - 36px)' # 36px = 2 * 18px grid padding
    ,
      breakpoint: 396 # default grid max-width
      width: '360px' # 396px - (2 * 18px padding)
    ,
      breakpoint: 600 # tablet grid breakpoint
      width: 'calc(50vw - 60px)'
        # 2 columns - (36px grid + 12px col + (2 * 6px img) padding)
    ,
      breakpoint: 732 # tablet grid max-width
      width: '318px' # (732px / 2 columns) - 60px
    ,
      breakpoint: 900 # desktop grid breakpoint
      width: 'calc(50vw - 138px)'
        # 2 columns - (48px grid + 18px col + (2 * 36px img) padding)
    ,
      breakpoint: 1056 # desktop grid max-width
      width: '390px' # (1056px / 2) - 138px
    ,
      breakpoint: 1200 # large desktop grid breakpoint
      width: 'calc(((100vw - 72px) / 3) - 60px)'
        # ((full viewport width - ((2 * 60px grid) - (2 * 24px row) padding)) /
        #   3 columns) - ((2 * 24px col) + (2 * 6px img) padding)
    ,
      breakpoint: 1440 # large desktop grid max-width
      width: '396px' # ((1440 - 72px) / 3) - 60px
  ]

  shouldComponentUpdate: (nextProps, nextState) ->
    # Component never updates after initial render
    return false

  render: ->
    srcSetAttrs =
      url: @props.image
      widths: [
        pixels: 300
        quality: 75
      ,
        pixels: 330
        quality: 75
      ,
        pixels: 360
        quality: 75
      ,
        pixels: 390
        quality: 75
      ,
        pixels: 600
        quality: 60
      ,
        pixels: 660
        quality: 60
      ,
        pixels: 720
        quality: 60
      ,
        pixels: 780
        quality: 60
      ]

    <Img
      srcSet={@getSrcSet srcSetAttrs}
      sizes={@getImgSizes @props.sizes}
      cssModifier=@props.cssModifier
      alt=@props.altText />
