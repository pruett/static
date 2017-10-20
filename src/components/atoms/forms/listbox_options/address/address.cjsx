[
  _
  React

  Address
  DownArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/address_v2/address_v2'
  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require '../listbox_option.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-listbox-option'

  VARIATION_CLASS: 'c-listbox-option--address'

  mixins: [
    Mixins.classes
  ]

  propTypes: ->
    optionData: React.PropTypes.object
    cssModifier: React.PropTypes.string
    showDownArrow: React.PropTypes.bool

  getDefaultProps: ->
    cssModifier: ''
    showDot: false
    showDownArrow: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssModifier}
    "
    address:
      'u-reset u-fs16'
    downArrow: "
      #{@BLOCK_CLASS}__down-arrow
      u-fill--light-gray
    "
    dot: "
      #{@BLOCK_CLASS}__dot
      u-fl
      u-mt8 u-mln4
    "
    content: "
      #{@BLOCK_CLASS}__content
      u-fl
      inspectlet-sensitive
    "

  classesWillUpdate: ->
    content:
      'u-pr8': @props.showDownArrow

  render: ->
    classes = @getClasses()

    <li {...@props}
      cssModifier={undefined}
      className=classes.block>

      {if @props.showDot
        <div key='dot' className=classes.dot />}

      <Address
        {...@props.optionData}
        key='address'
        cssModifier=classes.content />

      {if @props.showDownArrow
        <DownArrow cssModifier=classes.downArrow />}
    </li>
