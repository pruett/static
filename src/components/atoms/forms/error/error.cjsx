[
  React
] = [
  require 'react/addons'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-form-error'

  propTypes:
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: 'u-fs16 u-m0 u-color--yellow'

  render: ->
    return false unless @props.children

    <div className="#{@BLOCK_CLASS} #{@props.cssModifier}">
      {@props.children}
    </div>
