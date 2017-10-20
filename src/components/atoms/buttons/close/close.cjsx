_           = require 'lodash'
React       = require 'react/addons'
XIcon       = require 'components/quanta/icons/x/x'

module.exports = React.createClass
  BLOCK_CLASS: 'c-close-button'

  propTypes:
    title: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    title: 'Close'
    cssModifier: ''
    cssUtility: 'u-button -button-reset'

  handleClick: (event) ->
    event.preventDefault()
    ###
    # TODO: dispatch action
    ###

  render: ->
    props =
      className: "#{@BLOCK_CLASS} #{@props.cssUtility} #{@props.cssModifier}"
      onClick: @handleClick
      title: @props.title
      role: 'button'

    iconProps = _.omit @props, 'cssModifier', 'cssUtility'

    <button {...props}>
      <XIcon {...iconProps}/>
    </button>
