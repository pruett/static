_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './search.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--search'
    width: 16
    height: 15

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string


  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray-alt-2'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Search'>
      <g><path d="M7 13.16c3.27 0 5.923-2.702 5.923-6.032S10.27 1.098 7 1.098c-3.27 0-5.923 2.7-5.923 6.03S3.73 13.158 7 13.158zm0 1.095c-3.866 0-7-3.19-7-7.127S3.134 0 7 0s7 3.19 7 7.128c0 3.936-3.134 7.127-7 7.127z" fillRule="nonzero"/><rect transform="rotate(-50 13.364 12.96)" x="12.729" y="10.211" width="1.27" height="5.5" rx=".635"/></g>
    </Rsvg>

