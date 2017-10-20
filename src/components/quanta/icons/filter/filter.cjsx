_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './filter.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--filter'
    width: 13
    height: 13

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-stroke--dark-gray-alt-2'
    cssModifier: ''
    fill: 'white'

  render: ->
    fill = "u-fill--#{@props.fill}"
    <Rsvg {...@props} SVG={@SVG} title='Filter'>
      <path strokeLinecap='round' d='M1.5,0.5v12'/>
      <path strokeLinecap='round' d='M6.5,0.5v12'/>
      <path strokeLinecap='round' d='M11.5,0.5v12'/>
      <circle className=fill cx='11.5' cy='7.5' r='1.5'/>
      <circle className=fill cx='6.5' cy='3.5' r='1.5'/>
      <circle className=fill cx='1.5' cy='9.5' r='1.5'/>
    </Rsvg>
