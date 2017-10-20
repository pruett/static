_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './clear.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--clear'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Clear'>
      <path d='M8,0 C3.581722,0 0,3.5677309 0,7.96875 C0,12.3697691 3.581722,15.9375 8,15.9375 C12.418278,15.9375 16,12.3697691 16,7.96875 C16,3.5677309 12.418278,0 8,0 Z M8,14.9322917 C4.13196682,14.9322917 1,11.8125591 1,7.96875 C1,4.12494091 4.13196682,1.00520833 8,1.00520833 C11.8680332,1.00520833 15,4.12494091 15,7.96875 C15,11.8125591 11.8680332,14.9322917 8,14.9322917 Z'></path>
      <path d='M9.79289322,11.2071068 L10.5,11.9142136 L11.9142136,10.5 L11.2071068,9.79289322 L6.20710678,4.79289322 L5.5,4.08578644 L4.08578644,5.5 L4.79289322,6.20710678 L9.79289322,11.2071068 Z'></path>
      <path d='M4.79289322,9.79289322 L4.08578644,10.5 L5.5,11.9142136 L6.20710678,11.2071068 L11.2071068,6.20710678 L11.9142136,5.5 L10.5,4.08578644 L9.79289322,4.79289322 L4.79289322,9.79289322 Z'></path>
    </Rsvg>
