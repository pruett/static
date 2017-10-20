_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './info.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--info'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Info'>
      <path d='M16 8c0-4.418-3.582-8-8-8S0 3.582 0 8s3.582 8 8 8 8-3.582 8-8zM1 8c0-3.866 3.134-7 7-7s7 3.134 7 7-3.134 7-7 7-7-3.134-7-7z'/>
      <path d='M8.182 3.09c-1.89 0-2.52 1.162-2.52 1.722 0 .574.476.714.784.714.196 0 .504-.07.504-.504.014-.812.42-1.414 1.092-1.414.686 0 1.036.49 1.036 1.19 0 .532-.378 1.148-1.008 1.778-.7.7-1.106 1.302-1.106 1.862 0 .644.406 1.19 1.26 1.19.308 0 .672-.112.91-.308v-.322c-.07.014-.14.014-.224.014-.28 0-.672-.21-.672-.63 0-.392.308-.756.784-1.148.966-.77 1.358-1.302 1.358-2.156 0-1.134-.7-1.988-2.198-1.988zm-.224 9.464c.532 0 .854-.35.854-.826 0-.504-.322-.868-.84-.868-.49 0-.826.364-.826.868 0 .476.336.826.812.826z'/>
    </Rsvg>
