[
  React
  Rsvg
] = [
  require 'react/addons'
  require 'components/quanta/rsvg/rsvg'

  require '../customer_center.scss'
]

module.exports = React.createClass

  SVG:
    class: 'c-icon-customer-center--prescriptions'
    width: 72
    height: 72

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-icon u-fill--dark-gray'
    cssModifier: ''

  render: ->
    <Rsvg {...@props} SVG={@SVG}>
      <path d="M64.3 31.7c-.5-.3-.7-.8-1-1.2-.4-.4-.8-.7-1.2-1.1-.9-.8-1.8-1.6-2.6-2.5-1.5-1.9-3.2-3.6-5.1-5.2-.8-.7-1.6-1.4-2.5-2.1-.9-.7-1.7-1.5-2.6-2.2-.9-.7-1.8-1.3-2.6-2.1l-1.2-1.2c-.5-.4-1-.7-1.4-1.2-.7-.8-1.4-1.5-2.1-2.2-.7-.8-1.5-1.5-2.2-2.2-.4-.3-.8-.5-1.2-.3-.5.1-.5.8-.6 1.2-.2.6-.2 1.1-.4 1.7-.2.6-.4 1.3-.6 1.9-.3 1.1-.7 2.1-1.3 3-.6 1-1 2.1-1.7 3-.7.9-1.2 1.8-1.9 2.7-.8 1-1.7 1.9-2.5 2.9-3 3.7-6.7 7.1-10.9 9.3-1 .5-2 1.1-3.1 1.5-1.3.4-2.4.7-3.8.9-1.2.2-2.4.3-3.6.4-.8 0-1.7 1-.9 1.7.7.5 1.3 1.5 1.7 2.3l.6 1.5c.3.6.6 1.1.9 1.6l3.6 6.3c1.2 2.2 2.4 4.4 3.7 6.6.6 1 1.2 2 2 2.8.5.6 1.4 2.1 2.4 1.8.5-.2.6.3 1 .5s.9.2 1.3.4l1.5.6c.6.2 1.3 0 1.9.3.5.2 1 .1 1.5.3.6.2 1.2.1 1.8.1 1.2 0 2.3.1 3.5 0h.7c.1 0 .4.3.5.2.4-.2 1-.1 1.4-.3 1.1-.4 2.2-.9 3.3-1.2.5-.2 1.1-.3 1.6-.4.5-.2 1-.5 1.5-.7.5-.2 1-.3 1.5-.5.6-.2 1-.7 1.5-1 .9-.6 1.9-.9 2.7-1.5.4-.3.7-.7 1-1 .4-.4.9-.7 1.3-1.1 1.6-1.6 3.2-3.1 4.6-4.8.7-.9 1.5-1.7 2.1-2.6.3-.5.7-.8 1-1.2.4-.5.8-1.1 1.1-1.6.6-1 1-2 1.5-3s1.1-2.2 1.4-3.3c.2-.6.6-1.1.7-1.7l.6-2.1c.1-1 .8-3.2-.4-4-.2-.1.6.4 0 0zM33.2 62.2c-.7-.2-1.4-.3-2.1-.3-.8 0-1.5-.2-2.2-.3-.7-.1-1.4-.2-2.1-.4-.3-.1-.7-.1-1-.2-.3-.1-.5-.3-.7-.4.6-.8 1.6-1.4 2.3-2.1.8-.9 1.8-1.6 2.8-2.3.4-.3.6.6.7.9.3.6.7 1.1 1 1.7l2.1 3.3c-.2.2-.5.2-.8.1zm30-28.5c-1.3 4.8-2.8 9.9-6 13.8-.7.9-1.3 1.9-2 2.7-.8.9-1.6 1.9-2.5 2.7-1.8 1.7-3.6 3.5-5.7 4.8-2.1 1.4-4.3 2.3-6.7 3.2-1 .4-2.2.6-3.2 1.2-.3-.3-.7.2-1-.2-.4-.6-.8-1.2-1.2-1.7-.7-.8-1.3-1.9-1.9-2.8-.5-1-1-2.3-1.8-3.1-.8-.8-1.6.3-2.3.8-.9.7-1.7 1.6-2.7 2.4-.9.7-1.8 1.4-2.7 2.2-.2.2-.7.7-1 .5-.2-.1-.1-.3-.3-.5-.2-.2-.4-.2-.6-.5-.3-.4-.7-.7-1-1-.3-.4-.4-.8-.8-1.2-.4-.4-.6-.9-.8-1.4-.3-.5-.5-1.3-.9-1.7-.7-.7-1.2-1.8-1.6-2.7-.4-.9-1-1.7-1.5-2.6-.6-1.1-1.1-2.2-1.8-3.2-.2-.3-.6-.6-.6-1-.1-.4-.6-.9-.8-1.4-.4-1-1-1.8-1.4-2.8-.2-.5-.4-.9-.7-1.3-.1-.2-.8-1.1-.1-1.1 2.4.1 4.7-.6 6.9-1.5 1-.4 1.9-1.1 2.9-1.6 1.1-.6 2.2-1.3 3.2-2.1 1.9-1.5 3.8-3 5.5-4.8l1-1c.3-.3.4-.9.8-1.1.7-.7 1.3-1.4 2-2.2.3-.4.7-.7 1-1.1.3-.4.5-.9.8-1.2.2-.2.4-.6.6-.7.1-.1.2-.2.3-.4.1-.2.3-.4.5-.6.6-.7.9-1.7 1.5-2.5.7-1 1.1-2.1 1.5-3.3.2-.5.4-1.1.6-1.6.2-.5.2-1.1.4-1.5.1-.3.9.6 1 .7.5.5 1.1 1 1.6 1.6 1.7 1.7 3.6 3.1 5.3 4.8.8.8 1.7 1.4 2.5 2.2 1 .9 2 1.8 3.1 2.6 1.8 1.4 3.5 2.9 4.9 4.7 1.4 1.9 3.2 3.6 4.9 5.2.4.4.9.8.8 1.3-.4 1.3 0-.2 0 0z"/>
      <path d="M44.3 22.2c-.4-.3-.6-.7-1-1-.4-.3-1-.5-1.4-.6-.6-.2-2.7-1-2.9.1-.1.5-.5.9-.7 1.4-.3.5-.5 1-.8 1.5-.7 1.1-1.3 2.2-2 3.1-1.6 1.9-3 3.8-4.8 5.5-.5.5-1.8 1.7-.8 2.2.4.2.6.1 1-.1.1-.1.3-.1.4-.2.1-.1 0-.4.1-.5.7-.7 1.4-1.2 2-2 .3-.4.7-.8 1.1-1.2.4-.5.7-1 1.1-1.5 0 0 1.6.9 1.6 1.2 0 .6.1 1.1.2 1.6.1.7 0 1.3 0 1.9.1.9.2 1.8.3 2.6.1.6.2 1.2.3 1.9.1.8-.4.7-1.1.7-.8 0-2.6-.4-3.1.4-.7 1.1 1.5 1.4 2.1 1.4.6 0 1.3-.1 1.9-.1.5 0 .3.7.4 1 .2 1.1.5 2.2 1 3.2.2.5 1.1 1.5 1.7.9.1-.1.1-.8.2-.8.4.1.3.2.3-.2.1-.4-.4-.5-.5-.8l-.6-1.5c-.1-.4-.3-1-.4-1.4 0-.4.6-.3.9-.4.9-.3 2.2.1 3.1-.5.8-.5.9-1.8 0-2.3-.5-.2-.6.1-1.1.2-.5.1-1 .2-1.5.2-.6.1-1.4.4-1.6-.4-.6-2.2-.4-4.5-.6-6.7-.1-.6 0-.6.6-.5.4.1.9.1 1.4.1 1.1-.1 2.4-.7 3.4-1.3.9-.6 1.5-1.5 1.9-2.5.3-.9.3-2.4-.4-3.2-.6-.3-1.1-.9-1.7-1.4-.4-.4.6.5 0 0zm.5 3.5c0 .9-.4 1.8-1.1 2.3-.4.3-.8.4-1.2.5-.5.3-.8.5-1.3.5s-.4.4-.9.2c-.6-.2-1.2-.1-1.8-.4-.5-.3-2.2-1-1.7-1.7.7-.9 1.1-1.9 1.8-2.8.4-.6.6-2.6 1.7-2.3 1 .2 2.1.5 2.9 1.2.6.5 1.9 1.7 1.6 2.5 0 1.4.2-.4 0 0z"/>
    </Rsvg>
