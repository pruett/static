React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'
Mixins = require 'components/mixins/mixins'

require './add_check.scss'

module.exports = React.createClass

  mixins: [
    Mixins.classes
  ]

  SVG:
    class: 'c-icon--add-check'
    width: 26
    height: 26

  getDefaultProps: ->
    cssModifier: ''
    isChecked: false
    inactive: false

  getStaticClasses: ->
    block:  "
      #{@SVG.class}
      #{@props.cssModifier}
      u-icon
    "
    circle: "#{@SVG.class}__circle"
    plus:   "#{@SVG.class}__plus"
    check:  "#{@SVG.class}__check u-stroke--white"

  classesWillUpdate: ->
    block:
      'u-stroke--dark-gray-alt-2': not @props.isChecked
      'u-stroke--blue -checked': @props.isChecked and not @props.inactive
      'u-stroke--light-gray-alt-1 -checked': @props.isChecked and @props.inactive
    circle:
      'u-fill--white': not @props.isChecked
      'u-fill--blue': @props.isChecked and not @props.inactive
      'u-fill--light-gray-alt-1': @props.isChecked and @props.inactive
    plus:
      '-active': not @props.isChecked
    check:
      '-active': @props.isChecked

  render: ->
    classes = @getClasses()
    stroke = strokeWidth: '1.5', strokeLinecap: 'round'

    <Rsvg cssModifier=classes.block SVG=@SVG title='Add'>
      <g transform='translate(1 1)' fill='none'>
        <circle className=classes.circle strokeWidth='1.25' cx='12' cy='12' r='12' />
        <path {...stroke} className=classes.plus d='M12 7.25v9.5' />
        <path {...stroke} className=classes.plus d='M7.25 12h9.5' />
        <polyline {...stroke} className=classes.check points='7 11.6 10.13 15.2 16.39 8' />
      </g>
    </Rsvg>
