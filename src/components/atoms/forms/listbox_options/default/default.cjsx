[
  _
  React

  DownArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require '../listbox_option.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-listbox-option'

  VARIATION_CLASS: 'c-listbox-option--default'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssModifier}
      u-fws
      u-color--blue u-tac
    "
    downArrow: "
      #{@BLOCK_CLASS}__down-arrow
      u-fill--light-gray
    "
    plus:
      'u-sign -plus -w10 u-pr u-mr12 u-color--blue'

  render: ->
    classes = @getClasses()

    <li {...@props}
      cssModifier={undefined}
      className=classes.block>

      <span className=classes.plus />

      {@props.optionData.label}

      {if @props.showDownArrow
        <DownArrow cssModifier=classes.downArrow />}
    </li>
