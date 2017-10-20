[
  _
  React

  Checkbox

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/forms/checkbox/checkbox'

  require 'components/mixins/mixins'

  require './filter_checkbox.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-filter-checkbox'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    category: ''
    name: ''
    cssModifier: ''
    manageFilterChange: ->

  getInitialState: ->
    active: @props.active
    clearFiltersAfter: @props.clearFiltersAfter

  getStaticClasses: ->
    block: "
      u-reset
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "

  handleFilterChange: (event) ->
    nextActive = not @state.active
    action = if nextActive then 'check' else 'uncheck'
    target = _.camelCase "#{@props.category} #{@props.name}"
    @trackInteraction "gallery-#{action}-#{target}", event
    @setState active: nextActive
    @props.manageFilterChange(
      active: nextActive
      category: @props.category
      name: @props.name
    )

  componentWillReceiveProps: (nextProps) ->
    if nextProps.clearFiltersAfter isnt @state.clearFiltersAfter
      @setState
        active: false
        clearFiltersAfter: nextProps.clearFiltersAfter

  render: ->
    classes = @getClasses()

    checkProps =
      txtLabel: _.upperFirst @props.name
      colorSwatch: @props.category is 'color'
      cssModifierBox: '-border-light-gray'
      onChange: @handleFilterChange
      checked: @state.active

    <fieldset className=classes.block>
      <legend className="u-hide--visual">{"Filter #{@props.name}"}</legend>
      <Checkbox {...checkProps} />
    </fieldset>
