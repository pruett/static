[
  _
  React

  Rsvg

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require 'components/mixins/mixins'

  require './checkmark.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkmark-icon'

  mixins: [
    Mixins.classes
  ]

  SVG:
    class: 'c-icon--checkmark'
    width: 16
    height: 16

  propTypes:
    isChecked: React.PropTypes.bool
    disabled: React.PropTypes.bool
    hideBox: React.PropTypes.bool
    checkFill: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    isChecked: false
    disabled: false
    hideBox: false

    title: 'checkmark'
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''
    cssModifierBox: ''

  getStaticClasses: ->
    box: "
      #{@BLOCK_CLASS}__box
      #{@props.cssModifierBox}
    "
    check: "
      #{@BLOCK_CLASS}__check
    "

  classesWillUpdate: ->
    box:
      '-checked': @props.isChecked
      '-disabled': @props.disabled
    check:
      '-checked': @props.isChecked
      '-disabled': @props.disabled
      "-check-#{@props.checkFill}": _.isString @props.checkFill

  render: ->
    classes = @getClasses()

    <Rsvg {...@props} SVG=@SVG>
      {unless @props.hideBox
        <path className=classes.box d='M0 0h16v16H0z'/>}

      <path className=classes.check
        d='M5.8,8l1.7,1.7L12.3,5L14,6.7l-6.5,6.5L4,9.8L5.8,8z' />
    </Rsvg>
