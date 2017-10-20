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
    class: 'c-icon-customer-center--bookmarks'
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
      <path d="M68.1 47.3c0-1.2.1-2.5 0-3.7v-1.8c0-.7-.2-1.5-.2-2.2-.2-2.6-.2-5.3-.2-7.9v-3.6c0-1.3-.3-2.7-.2-4 .1-1.2-.2-2.5-.3-3.8-.1-1.4-.1-2.8-.1-4.1 0-1.1 0-2.1-1.2-2.5-.6-.2-1-.1-1.6-.1-.5 0-.2-.5-.2-.8 0-.5.5-.9-.1-1.3-.4-.3-.9-.2-1.3-.1-.3.1-.4.3-.7.4-.3.1-.5 0-.8.1-.7.2-1.3.4-2 .6-2.5.7-4.7 1.6-7.1 2.5-2.3.8-4.4 1.9-6.5 3-.8.4-1.6.9-2.5 1.3-.8.4-1.4 1-2.1 1.5-.8.5-1.7.9-2.5 1.4-.4.3-.8.5-1.3.8-.5.2-.6.2-1.1 0-.8-.4-1.6-.8-2.5-1.1-.4-.1-1.8-.2-1.7-.9.1-.5.2-.9.2-1.4v-1.5c.1-.4-.1-.8-.1-1.3-.1-.6.1-1.1.1-1.7.1-.8.2-2.1-.2-2.9-.2-.4-.6-.3-.9-.3-.4-.1-.9-.3-1.3-.4-.8-.3-1.7-.7-2.5-.8-.4-.1-.7-.1-1.2-.2-.4-.1-.9-.2-1.4-.3-.7-.1-1.8-.1-2.4.3-.8.4-.6 1-.5 1.8 0 .4-.1.8 0 1.2.1.4-.2.7-.1 1.1.1.3-.2.6-.2 1-.1.5.1.8 0 1.2-.8-.6-1.8-1-2.8-1.4-.5-.2-1-.4-1.6-.4-.4-.1-1.1-.4-1.5-.6-1.1-.4-2.2-.8-3.3-1.1-1.2-.4-2.4-.6-3.6-1.1-.5-.2-.8.3-.8.7 0 .3-.1.5-.2.8 0-.1.3.3.2.2.7 1.3-2 .5-2.4.4-1.3-.1-.6.6-1 1.4-.3.5-.2 1-.1 1.5.1.7 0 1.3 0 2 0 1.2 0 2.5.1 3.7.1 1.2.1 2.5.1 3.7l-.3 7.8c0 1.3-.2 2.5-.4 3.8-.2 1.3-.2 2.6-.1 3.9 0 2.6-.1 5.1.2 7.7.2.3.1.8.1 1.5s.4.8.9 1.3c.9.8 1.9 1.2 2.9 1.8.2.1.5.2.8.3.2.1.5 0 .6.2.4.3.8.5 1.3.6 1.3.3 2.5.8 3.8 1.1 1.2.3 2.2.7 3.3 1.2 1.2.5 2.4 1.2 3.7 1.5 2.5.6 5.1.6 7.6 1 1.2.2 2.2.6 3.3 1.1l1.5.6c.2.1.5.2.8.1.3 0 .5-.2.8-.1.9.3 1.8-.5 2.7-.7 1.2-.3 2.3-.7 3.4-1.2 1-.4 2.1-.7 3.1-1.1.5-.2 1.1-.4 1.6-.5.6-.2 1.2-.5 1.8-.7.5-.2.9-.3 1.4-.3.5-.1.8-.4 1.3-.5 1-.2 1.9-.5 2.9-.7.8-.2 1.5-.4 2.2-.8.7-.3 1.6-.3 2.3-.7.7-.4 1.7-.5 2.5-.6.4-.1.9-.2 1.3-.4.4-.1.8-.1 1.3-.1.8-.1 1.6-.6 2.3-.9.6-.2 1.3-.3 1.5-1 .1-.2.6-.1.7-.2.3-.1.5-.5.5-.8.1-1.3.1-2.4 0-3.5zm-46.2-14c.1-.5-.1-1.2-.1-1.8.1-.7.3-1.3.2-2 0-1.4 0-2.8.2-4.3.1-1.4.4-2.9.5-4.3.1-1.5-.2-3 .2-4.5.1-.7.3-1.4.3-2.1 0-.7-.1-1.4 0-2 .1-.5 0-1 .7-1.1.6-.1 1.3.1 1.9.2 1.4.2 2.8.7 4.1 1.1.8.2.8.3.9 1.1 0 .6-.3 1.3.5 1.3-.7.4-.5 1.2-.5 1.9 0 1 .1 2.1 0 3.1s-.3 2-.4 3.1c-.1 1.1-.5 2.2-.5 3.3 0 1-.2 2-.3 2.9-.1 1-.2 1.9-.2 2.9-.2 2.2-.2 4.3-.6 6.5-.3 1.9-.1 3.9-.6 5.8-.1.3-.2.8-.6.5-.3-.3-.8-.3-1.2-.5-.9-.4-1.6-1.1-2.6-1.2-.4-.1-1.9-.4-1.8-.9 0-1-.1-2-.1-3-.2-1.9-.5-4.1 0-6 0-.3-.4 1.3 0 0zm8.7 25.9c-.1-.3-.7-.1-1.1-.2-.6-.1-1.2-.3-1.8-.4-.6-.1-1.2-.1-1.8-.2-.7-.1-1.3-.3-1.9-.3-2.5-.1-4.9-1.4-7.2-2.2-1.1-.4-2.3-.8-3.4-1.2-1.2-.4-2.2-1.1-3.4-1.4-.5-.2-1-.3-1.5-.5-.4-.2-.7-.6-1.1-.7-.5-.2-1.1-.3-1.6-.5-.7-.2-.6-.6-.6-1.3 0-1.2-.2-2.3-.2-3.5 0-.2-.1-.5-.1-.7.1-.1.1-.2.1-.4 0-.7.1-1.3 0-2-.1-1.2 0-2.5 0-3.7 0-1.3.3-2.6.4-3.9.1-1.2.3-2.4.3-3.7 0-1.3 0-2.7.1-4 .2-2.5.4-5.1 0-7.6-.1-.6-.2-1.1-.1-1.7.1-.6 0-1.2.1-1.7 0-.2.2-.3.1-.5s-.2-.2-.2-.3c0-.3.1-.7.3-1 .3-.7 1.3-.5 1.9-.3.2.1.3.2.3.5 0 .7-.2 1.3-.2 2-.1 2.6.1 5.2 0 7.8-.1 1.2-.1 2.5-.3 3.8-.2 1.3-.2 2.6-.2 3.9-.2 2.6-.1 5.3-.3 7.9-.2 1-.2 2.3-.2 3.6 0 1.3-.2 2.7 0 4 0 .3.1.8.2 1.1.3.3 1 .5 1.4.7 1.1.6 2.3.9 3.6 1.2 1.2.3 2.3.6 3.5 1 1.2.4 2.3 1.1 3.5 1.4 1.3.2 2.4.9 3.5 1.4 1.2.6 2.5.9 3.8 1.3 1.4.4 2.7 1 4 1.6.6.3 1.3.6 1.9.9.3.2 1.5.6 1.4 1.1-1-.5-2-.9-3.2-1.3zm4.7-21.5c.1 3.5-.5 7.1-.6 10.6-.1 1.8-.2 3.5-.3 5.3-.1 1.8 0 3.5-.1 5.3-.2 0-.4-.4-.6-.4-.2.1-.6-.2-.8-.4-.4-.2-.8-.6-1.2-.8-.5-.3-1.1-.4-1.7-.6-1.1-.5-2.1-1-3.2-1.3-1.2-.3-2.4-.6-3.5-1.2-.5-.3-1.1-.6-1.7-.8-.3-.1-.6-.3-.9-.4-.2-.1-.4 0-.6-.1-.5-.1-.9-.4-1.4-.5-.6-.2-1.2-.5-1.9-.7-1.1-.4-2.3-.8-3.4-1.1-.5-.1-.8-.2-1.3-.2-.6-.1-1.2-.3-1.7-.6-.6-.3-2.2-.7-2.1-1.6.2-1.3-.1-2.6-.1-3.9 0-1.2.1-2.4.1-3.6 0-1.4 0-2.7.2-4.1.1-1.2 0-2.4.1-3.5.1-1.4.2-2.7.3-4.1.1-1.2.4-2.5.4-3.7 0-1.4.1-2.7 0-4.1 0-1.9-.2-3.8.1-5.7.1-.4.1-2 .7-1.9.7.1 1.5.4 2.2.6 1.5.4 3 .9 4.5 1.4.8.3 1.6.5 2.4.9.5.2 1.7 1.1 2.2.7 0 1.4.2 2.9-.1 4.3-.1.6-.1 1.3-.3 1.9-.1.5-1-.2-1.3-.3-.6-.2-1.3-.4-1.9-.6-.7-.3-1.3-.5-2.1-.5-.9-.1-3.2-.8-3.4.5-.1.7 3 .9 3.5.9 1.4.2 2.7.7 4 1.3.5.2.9.3.9.9 0 .7 0 1.3-.1 2-.1 1.4-.1 2.8-.1 4.2-.2-.4-.5-.4-.9-.5-.5-.2-1-.4-1.5-.5-.5-.1-1 0-1.5-.2-.6-.2-1.3-.4-1.9-.5-.7-.1-2.3-.9-2.6.1-.3 1.2 1.9 1.1 2.6 1.3 1.2.2 2.4.5 3.6.8.5.1 1.1.3 1.6.6s.4.8.3 1.3c-.2 1.1.1 2.1 0 3.2-.1.6 0 1.1 0 1.7.1.8-.3.5-.9.4-1.1-.3-2.2-.2-3.3-.6-.2-.1-.4-.2-.6-.2-.2 0-.3.2-.5.1-.6-.3-1.2-.3-1.8-.2-.4 0-1-.1-1.2.3-.1.2-.3.7 0 .8 1.1.2 2.3.4 3.4.5 1.1.1 2.3.4 3.4.6.4.1 1.2.1 1.4.5.2.4.1 1 .1 1.4 0 .8.1 1.4.9 1.7 1.1.4 2.2.9 3.3 1.3.4.2.7 0 1 .4.2.3.6.4.8.5.2.1.5.6.7.4.5-.3.8.2 1.3.1.1 0 .9-.4.9-.5 0-.5.2-.9.3-1.4.1-.3.1-1 .3-1.2.4-.3.9.2 1.2-.4.3-.8-.9-1-.9-1.1-.1.4-.4.2-.3-.2l.3-2.1c.1-1.2.3-2.3.4-3.5 0-.6 0-.6.6-.7.2 0 .9-.7.5-.8-.3-.1-.3-.5-.6-.7-.4-.2-.2-.7-.2-1.1 0-1.3.2-2.5.3-3.8 0-.2.7-.1.9-.2.3-.1.8-.7.4-.8-.3-.1-.5-.6-.7-.7-.6-.1-.5-.6-.4-1.1.1-.6.1-1.2.2-1.9.1-.6.3-1.1.4-1.7.1-.6.2-.4.7-.2l1.5.6c.5.1.9.5 1.4.7.1.1.4 0 .5.1.1.2-.1.5-.1.7-.1 1.1-.4 2.2-.4 3.3 0 .8 0 1.6-.1 2.4-.1.7 0 1.4 0 2.2-.1.8-.3 1.5-.2 2.3.2.7.1 1.5.2 2.4 0 1.2-.1-1 0 0zm.3 21.7c-.2-.2 0-.6 0-.9 0-.7-.1-1.3-.1-1.9 0-1.3 0-2.7.1-4 .1-2.5.4-5 .4-7.4.1-2.5.5-5 .4-7.5-.1-2.6.2-5.2.6-7.8.2-1.1.2-2.3.3-3.4.1-.5 0-1.3.2-1.8.1-.4 1.1-.8 1.4-1 1-.6 2-1.3 2.9-1.9.5-.3 1-.7 1.5-1 .4-.3.8-.7 1.3-.6.1 0 .2-.3.2-.3.1-.2.4-.2.6-.3.5-.3 1-.5 1.5-.8 1.1-.5 2.3-.9 3.3-1.5s2.2-.9 3.3-1.3c1.2-.5 2.4-1.1 3.7-1.5 1.1-.4 2.3-.5 3.5-.8.6-.1 2.4-1.2 2.2 0-.2 1.2.1 2.4.1 3.6 0 .6-.1 1.2-.1 1.7 0 .7.1 1.3.1 2v3.8c0 1.3-.1 2.7 0 4 .1 1.2.3 2.4.3 3.6 0 1.4.1 2.7.1 4.1.1 2.5.2 4.9.2 7.4 0 1.2.1 2.4 0 3.6 0 .5-.3 0-.5.2-.4.4-1 .5-1.6.6-1.1.3-2.2.7-3.4 1-1.3.3-2.5.6-3.8 1-1.1.4-2.1.9-3.2 1.2-.5.2-1 .3-1.5.6-.6.3-1.2.2-1.8.5-1 .5-1.9 1-2.9 1.6-1 .5-2.2.7-3.2 1.3-1 .6-2.2 1-3.2 1.6-.9.7-1.9 1.5-2.9 2.3zm31.1-9.8c-.2 1.1-1.9 1.7-2.8 1.9-1.3.4-2.6.5-3.9.9-1.3.4-2.7.6-4 1.1-1.3.6-2.6 1.2-4 1.6-1.4.4-2.8.5-4.2 1-1.5.5-2.9 1-4.4 1.5-.6.2-1.2.3-1.7.7-.4.3-1.1 0-1.4.4-.4.4-1 .4-1.4.5-.3.1-.6.2-.9.4-.2.1-.3-.1-.5-.1.7-.7 1.6-1.1 2.4-1.7.4-.3 1-.4 1.4-.6.6-.2 1.3-.5 1.9-.8 1.1-.5 2.2-1 3.3-1.6 1.1-.6 2.1-.9 3.3-1.3 1-.3 2-.9 3-1.2 1.2-.4 2.4-.9 3.7-1.3 1.2-.4 2.3-.5 3.5-.8.6-.2 1.1-.4 1.7-.6.6-.2 1-.2 1.5-.6.6-.5 1.6.6 1.8-.4.1-.6.3-1.1.2-1.7 0-.4-.2-.4 0-.8.1-.3.1-.7 0-1-.2-1.2 0-2.4-.2-3.6-.1-.6-.1-1.2-.1-1.8 0-.7 0-1.2-.1-1.9 0-.6 0-1.2-.1-1.7-.1-.4.1-.4.1-.8 0-.3-.1-.5-.1-.8 0-.6-.1-1.2-.2-1.8 0-.6.2-1.3 0-1.9-.2-.5-.1-1-.1-1.5 0-.6-.1-1.2-.1-1.8-.1-1.3-.1-2.7-.2-4 0-.4 0-.8-.1-1.2 0-.2.3-.6.3-.8.1-.9 0-1.7.1-2.5.1-.9 0-1.6-.1-2.4 0-.2-.1-1.1 0-1.2.3-.3.9 0 1.2-.1.6-.1.4 1.2.3 1.5 0 1 0 2.1.1 3.1.1 2 .3 4 .3 6-.1 1.9.3 3.9.2 5.8 0 1.9-.1 3.9.1 5.8.2 2 .2 4 .3 6.1v3c0 .9.1 2-.1 3z"/>
      <path d="M41.1 50.9c.9-.3 1.6-1 2.4-1.5.6-.4 1.3-1.2 2-1.3.4-.1.3-.2.6-.5.4-.3.9-.5 1.3-.7l3-1.5c.9-.4 2.1-.6 3-.9 1.1-.4 2.2-.7 3.3-.9.9-.1 1.8.1 2.5-.5.6-.4 1-1.4 0-1.4s-2.1.2-3.1.4-2 .3-2.9.7c-1.9.6-3.8 1.2-5.6 2.2-.9.5-1.8.8-2.6 1.4-.8.6-1.8 1-2.5 1.6-.3.3-.6.4-.9.7-.4.2-.6.7-1 .9-.3.2-.8.4-.6.9.3.3.7.5 1.1.4 1.1-.4-.4.1 0 0zM41.1 44.1c.8-.1 1.5-.9 2-1.3.7-.6 1.5-1.2 2.3-1.8 1.4-1.2 2.9-2.2 4.6-3 1.6-.7 3.6-1.3 5.3-1.5.4-.1.8 0 1.2-.2.4-.2.6 0 .9-.3.6-.5 1.4-1.1.4-1.6-.6-.3-1.7.2-2.3.3-1 .2-1.9.4-2.9.7-1.9.5-3.7 1.1-5.3 2.2-1.6 1.1-3.2 2.3-4.7 3.5-.4.3-.7.6-1.1.9-.4.3-.8.5-1.1.8-.5.5 0 1.4.7 1.3.5 0-.4.1 0 0zM41.7 29.2c.2-.3.5-.6.8-.8.2-.2.6-.1.8-.4 0-.1.1-.1.2-.1 0-.1 0-.3.2-.4.2-.1.5-.2.7-.2.2 0 .6-.5.9-.6.4-.2.9-.4 1.3-.7.9-.6 1.8-1 2.8-1.5.8-.4 1.6-.9 2.3-1.4.3-.2.8-.3 1.2-.4.5-.2 1-.5 1.5-.7.9-.3 1.9-.3 2.8-.5.4-.1.6.1 1-.2.2-.1.8-.5.6-.8-.6-.8-1-.8-1.9-.6-1.1.2-2.1.3-3.2.7-.9.4-1.7.9-2.6 1.2-.9.3-1.7.9-2.6 1.4-.9.5-1.7.9-2.6 1.4-.9.5-1.7 1.1-2.6 1.7-.9.5-1.8 1.1-2.6 1.8-.8.5.4 1.8 1 1.1.4-.4-.3.3 0 0zM54.9 27.4C51.4 28.7 48 29.7 45 32c-.7.6-1.4 1.1-2.1 1.7-.7.5-1.5.9-2.1 1.5-.4.4-.5 1.2.1 1.4.8.3 1.7-.8 2.2-1.2.7-.5 1.4-.9 1.9-1.6.5-.7 1.5-1.1 2.2-1.5.3-.1.7-.3.9-.6.2-.3.6-.3 1-.4.8-.3 1.6-.8 2.4-1.2.3-.1.6-.3 1-.4.4-.2.7 0 1.1-.1.8-.4 1.4-.7 2.3-.8.2 0 1-.5.9-.8-.3-1-1.1-.9-1.9-.6-.6.2.4-.2 0 0zM30.5 50.3c-1.4-1-3.4-1.6-5.1-2.1-.9-.3-1.8-.5-2.6-.8-.9-.4-1.8-.4-2.6-.7-1.7-.6-3.5-1.1-5.2-1.4-.9-.2-1.8-.3-2.7-.2-.3 0-.6-.1-.8.2-.2.3 0 .7.3.9.3.2.7.1 1 .1.5 0 1 .1 1.4.2 1 .2 2 .4 2.9.7.9.3 1.7.6 2.6.8.9.2 1.9.3 2.8.6 1.8.6 3.5 1.2 5.2 1.8l.9.3c.4.2.6.5.9.7.6.4 1.7-.5 1-1.1z"/>
    </Rsvg>
