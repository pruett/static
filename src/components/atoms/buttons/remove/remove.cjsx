[
  _
  React
  XIcon
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'

  require './remove.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-remove-button'

  propTypes:
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    onClick: React.PropTypes.func
    title: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: 'u-button -button-reset'
    onClick: ->
    title: 'Remove'

  render: ->
    props =
      className: [
        @BLOCK_CLASS
        @props.cssUtility
        @props.cssModifier
      ].join ' '
      onClick: @props.onClick
      title: @props.title
      role: 'button'

    iconProps = _.omit @props, 'className', 'cssModifier', 'cssUtility'

    <button {...props}>
      <XIcon {...iconProps} />
      <span
        children=@props.title
        className="#{@BLOCK_CLASS}__title u-reset u-fws u-ffss" />
    </button>
