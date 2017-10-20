_     = require 'lodash'
React = require 'react/addons'
Rsvg  = require 'components/quanta/rsvg/rsvg'

require './add.scss'

module.exports = React.createClass

  SVG:
    class: 'c-icon--add'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Add'>
      <path d="M7 4h2v8H7V4zM4 7h8v2H4V7z"/>
      <path d="M8 0C3.6 0 0 3.6 0 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8zm0 14.9c-3.9 0-7-3.1-7-7s3.1-7 7-7 7 3.1 7 7-3.1 7-7 7z"/>
      <path d="M8.5 776c-4.4 0-8 3.6-8 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8zm0 14.9c-3.9 0-7-3.1-7-7s3.1-7 7-7 7 3.1 7 7-3.1 7-7 7z"/>
      <path d="M-263 580v1500h1440V580H-263zM14.5 793h-12v-18h12v18z"/>
      <path d="M-263 580v1500h1440V580H-263zM17.5 790h-18v-12h18v12z"/>
      <path d="M-263 580v1500h1440V580H-263zM8.5 791.9c-4.4 0-8-3.6-8-8s3.6-8 8-8 8 3.6 8 8c0 4.5-3.6 8-8 8z"/>
      <path d="M2.5 775h12v18h-12z"/>
      <path d="M-.5 778h18v12h-18z"/>
      <path d="M1.5,784a7,7 0 1,0 14,0a7,7 0 1,0 -14,0"/>
    </Rsvg>
