_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './delete.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--delete'
    width: 10
    height: 12

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Delete'>
      <path d="M1 1h8v2H1zM1 4h8v7H1z"/>
      <path d="M3 0h4v1H3z"/>
      <circle cx="1" cy="2" r="1"/>
      <circle cx="2" cy="11" r="1"/>
      <circle cx="8" cy="11" r="1"/>
      <circle cx="9" cy="2" r="1"/>
      <path d="M9 2h1v1H9z"/>
      <path d="M0 2h1v1H0zM2 11h6v1H2z"/>
    </Rsvg>
