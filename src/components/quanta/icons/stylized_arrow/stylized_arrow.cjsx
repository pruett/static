_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

module.exports = React.createClass

  SVG:
    class: 'c-icon--stylized-arrow'
    width: 72
    height: 25

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Stylized Arrow'>
      <path d="M69 8.5V7.2c0-1.6-.4-2-1.9-2-1.7.1-3.3-.4-4.8-.9-1.3-.5-2.5-1.1-3.9-1.3-1-.1-1.7.2-1.9 1.2-.3 1.1.2 1.8 1.3 2.2 1.2.3 2.3.6 3.5.9.2 0 .4.1.5.3.1.3-.2.4-.3.5-.8.4-1.5.6-2.1.9-4.3 2.7-9.1 4.2-14 5.2-5 1.1-10.1 1.8-15.2 2.2-2.7.2-5.3.4-8 0-4.4-.6-8.6-1.6-12.7-3.2-1.7-.6-3.2-1.6-5.1-1.5-1.2.1-1.7.7-1.2 1.9.4 1 1.3 1.6 2.3 1.9 1.8.6 3.5 1.3 5.3 1.9 1.8.6 3.6 1 5.4 1.5 1.4.4 2.7.4 4.1.5 1.6.1 3.1.6 4.7.5 3.4-.3 6.7-1.1 10.1-.5.3.1.6 0 .9-.1 1.7-.3 3.4-.9 5.1-1.3 3.8-.8 7.6-1.4 11.4-2.5 1.9-.6 3.8-1.1 5.5-2.4 1.2-1 2.8-1.5 4.3-2.2.7-.3 1.6 0 2.3-.4.2-.1.6-.5.8-.1.2.2.2.7 0 .9-.8.9-.5 2-.8 3-.1.7.4 1.2 1 1.5.4.2 1 .3 1.1-.1.2-.8.9-1.1 1.2-1.8.6-1.7 1.3-3.4 1.1-5.4z"/>
    </Rsvg>
