[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './shipping_address_notice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-shipping-address-notice'

  mixins: [
    Mixins.analytics
  ]

  handleClick: (title, event) ->
    @props.onClick(event) if _.isFunction(@props.onClick)
    @clickInteraction title, event

  render: ->
    <p className="#{@BLOCK_CLASS} u-reset u-fs12">
      If you need to edit your shipping address, please call us
      at <a href='tel:888.492.7297' onClick={@handleClick.bind(@, 'phone')}>888.492.7297</a>, Monday through
      Friday, 9 a.m. to 9 p.m. Eastern.
    </p>
