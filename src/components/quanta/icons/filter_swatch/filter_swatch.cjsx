[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './filter_swatch.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-filter-swatch'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssModifier: ''
    txtLabel: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      -#{@props.txtLabel.toLowerCase()}
    "

  render: ->
    classes = @getClasses()

    <span className=classes.block />
