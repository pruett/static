[
  _
  React

  Img
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require './fixed_aspect_ratio.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-fixed-aspect-ratio-image'

  propTypes:
    aspectRatio: React.PropTypes.number
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    # You can pass this component any props that you want to apply to the
    # plain ol' <img> component it'll ultimately generate. E.g. `alt`.
    aspectRatio: 1    # Ratio of width to height
    cssModifier: ''

  render: ->
    imageProps = _.omit @props, 'aspectRatio', 'cssModifier'
    imageWrapStyle = paddingTop: "#{1 / @props.aspectRatio * 100}%"

    # If defining a width with CSS, you must define it on this outermost div.
    # Defining it on the inner div will mess up the image sizing.
    <div className="#{@BLOCK_CLASS} #{@props.cssModifier}">
      <div className="#{@BLOCK_CLASS}__image-wrap" style=imageWrapStyle>
        <Img {...imageProps} cssModifier="#{@BLOCK_CLASS}__image" />
      </div>
    </div>
