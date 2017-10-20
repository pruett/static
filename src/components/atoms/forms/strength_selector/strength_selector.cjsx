[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'

  require './strength_selector.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-strength-selector'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    size: React.PropTypes.number
    step: React.PropTypes.number
    name: React.PropTypes.string
    selected: React.PropTypes.string

  getDefaultProps: ->
    size: 12
    step: 0.25
    name: 'strength'
    selected: ''

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    strength:
      "#{@BLOCK_CLASS}__strength"
    input:
      "#{@BLOCK_CLASS}__input u-hide--visual"
    label: "
      #{@BLOCK_CLASS}__label
      u-pa u-w100p u-h100p
      u-color--dark-gray
    "
    labelContent: '
      u-pa u-center
      u-pen u-fws
    '

  renderRow: (start) ->
    end = start + 1

    <tr
      key="row-#{start}"
      children={@renderCell(i) for i in [start...end] by @props.step} />

  renderCell: (strength) ->
    <td key=strength
      className="#{@classes.strength} #{['-disabled' if strength is 0]}">

      <input {...@props}
        name=@props.name
        type='radio'
        id="strength-#{strength}"
        value=strength
        disabled={strength is 0}
        defaultChecked={parseFloat(@props.selected) is strength}
        className=@classes.input />

      <label htmlFor="strength-#{strength}"
        className="
          #{@classes.label}
          #{['-disabled' if strength is 0]}
          #{['-active' if @props.selected]}">

        <span
          className=@classes.labelContent
          children={if strength is 0 then '0' else "+#{strength.toFixed(2)}"} />

      </label>

    </td>

  render: ->
    @classes = @getClasses()

    rows = @props.size * @props.step

    <table
      className=@classes.block
      children={@renderRow(i) for i in [0...rows]} />
