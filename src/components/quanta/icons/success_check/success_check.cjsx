React = require 'react/addons'
Rsvg = require 'components/quanta/rsvg/rsvg'
Mixins = require 'components/mixins/mixins'

require './success_check.scss'

module.exports = React.createClass

  mixins: [
    Mixins.classes
  ]

  SVG:
    class: 'c-icon--success-check'
    width: 82
    height: 82

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''

  getStaticClasses: ->
    circle: "
      #{@BLOCK_CLASS}__circle
      u-fill--blue
    "
    check: "
      #{@BLOCK_CLASS}__check
      u-fill--white
    "

  render: ->
    classes = @getClasses()

    <Rsvg {...@props} SVG={@SVG} title='Success Check'>
      <path className=classes.circle d="M41 81c22.09 0 40-17.91 40-40S63.09 1 41 1 1 18.91 1 41s17.91 40 40 40z"/>
      <path className=classes.check d="M37.973 43.876l-6.052-6.053-3.63 3.632 7.262 7.263 2.42 2.42 16.95-16.947-3.632-3.63-13.317 13.316z"/>
    </Rsvg>
