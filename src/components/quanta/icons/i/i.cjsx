[
  React

  Rsvg
] = [
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require './i.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon--i'
    width: 16
    height: 16

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    fillBackground: React.PropTypes.bool

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''
    fillBackground: false

  render: ->
    <Rsvg {...@props} SVG={@SVG} title='Info'>
      {unless @props.fillBackground
        <path d='M16,8 C16,3.581722 12.418278,0 8,0 C3.581722,0 0,3.581722 0,8 C0,12.418278 3.581722,16 8,16 C12.418278,16 16,12.418278 16,8 Z M1,8 C1,4.13400675 4.13400675,1 8,1 C11.8659932,1 15,4.13400675 15,8 C15,11.8659932 11.8659932,15 8,15 C4.13400675,15 1,11.8659932 1,8 Z'></path>
      else
        <path d='M16,8 C16,3.581722 12.418278,0 8,0 C3.581722,0 0,3.581722 0,8 C0,12.418278 3.581722,16 8,16 C12.418278,16 16,12.418278 16,8 Z'></path>}
      <path fill={if @props.fillBackground then '#ffffff' else 'inherit'}
        d='M8,3.79998779 C7.424,3.79998779 7.112,4.19598779 7.112,4.68798779 C7.112,5.16798779 7.424,5.57598779 7.988,5.57598779 C8.552,5.57598779 8.888,5.16798779 8.888,4.68798779 C8.888,4.19598779 8.564,3.79998779 8,3.79998779 L8,3.79998779 Z M7.256,11.004 C7.256,11.508 7.184,11.544 6.5,11.592 L6.5,12 L9.584,12 L9.584,11.592 C8.9,11.544 8.828,11.508 8.828,11.004 L8.828,6.408 L8.744,6.336 L6.572,6.66 L6.572,7.044 L6.968,7.104 C7.172,7.128 7.256,7.212 7.256,7.656 L7.256,11.004 Z'></path>
    </Rsvg>
