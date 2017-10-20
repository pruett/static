[
  _
  React

  Rsvg
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/rsvg/rsvg'

  require './reload_arrow.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon--reload-arrow c-reload-arrow'
    width: 20
    height: 19

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--blue'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
        <path d='M7,17 L7,17 C9.76142375,17 12,14.7614237 12,12 C12,9.23857625
          9.76142375,7 7,7 C4.23857625,7 2,9.23857625 2,12 C2,14.7614237
          4.23857625,17 7,17 L7,17 Z M0,12 C0,8.13400675 3.13400675,5 7,5
          C10.8659932,5 14,8.13400675 14,12 C14,15.8659932 10.8659932,19 7,19
          3.13400675,19 0,15.8659932 0,12 Z' />
        <rect className='c-reload-arrow__spacer' x=8.64711432 y=1.64711432 width=9 height=9 />
        <path d="M7,9 L7,3 L12,6 L7,9 Z" />
    </Rsvg>
