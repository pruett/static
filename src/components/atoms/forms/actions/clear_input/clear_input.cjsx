[
  React

  ClearIcon
] = [
  require 'react/addons'

  require 'components/quanta/icons/clear/clear'

  require './clear_input.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-clear-input'

  propTypes:
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    cssUtility: ''

  render: ->
    className = [
      @BLOCK_CLASS
      @props.cssUtility
      @props.cssModifier
    ].join ' '

    <button {...@props} className=className type='button' tabIndex=-1>
      <ClearIcon />
    </button>
