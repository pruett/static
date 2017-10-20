[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './return_exchange_notice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-return-exchange-notice'

  mixins: [
    Mixins.analytics
  ]

  handleClick: (title, event) ->
    @props.onClick(event) if _.isFunction(@props.onClick)
    @clickInteraction title, event

  render: ->
    <p className="#{@BLOCK_CLASS} u-reset u-fs16">
      <strong>Not satisfied?</strong><br />
      Give us a call at <a href='tel:888.492.7297' onClick={@handleClick.bind(@, 'phone')}>888.492.7297</a>,
      Monday–Friday, 9 a.m.–9 p.m. ET, or email us
      at <a href='mailto:help@warbyparker.com' onClick={@handleClick.bind(@, 'email')}>help@warbyparker.com</a> so
      we can get started on the return or exchange process. We’d
      love to hear your feedback too.
    </p>
