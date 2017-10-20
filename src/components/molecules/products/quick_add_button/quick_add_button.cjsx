_ = require 'lodash'
React = require 'react/addons'
AddIcon = require 'components/quanta/icons/add_check/add_check'
Tooltip = require 'components/atoms/tooltip_standalone/tooltip_standalone'
Mixins = require 'components/mixins/mixins'

require './quick_add_button.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-quick-add-button'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''
    handleClick: ->
    inCart: false
    showTooltip: false
    tooltipCopy: 'Add to your Home Try-On'

  getInitialState: ->
    activePopover: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    button: "
      #{@BLOCK_CLASS}__button
      u-button-reset
    "
    tooltip: '
      u-pa u-l0
      u-fs16 u-wsnw
      u-fws
    '

  render: ->
    classes = @getClasses()

    <span className=classes.block>
      <button className=classes.button onClick=@props.handleClick>
        <AddIcon isChecked=@props.inCart />
      </button>

      {if @props.showTooltip
        <Tooltip
          cssModifier=classes.tooltip
          children=@props.tooltipCopy />}
    </span>
