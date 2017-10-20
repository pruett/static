[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './totals_table.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-totals-table'

  mixins: [
    Mixins.conversion
  ]

  propTypes:
    balance_cents: React.PropTypes.number
    cssModifier: React.PropTypes.string
    discount_cents: React.PropTypes.number
    gift_card_cents: React.PropTypes.number
    shipping_cents: React.PropTypes.number
    subtotal_cents: React.PropTypes.number
    tax_cents: React.PropTypes.number
    total_cents: React.PropTypes.number

  getPropTypes: ->
    balance_cents: null
    cssModifier: ''
    discount_cents: 0
    gift_card_cents: 0
    shipping_cents: 0
    subtotal_cents: 0
    tax_cents: 0
    total_cents: 0

  rows: [
    label: 'Subtotal:'
    prop: 'subtotal'
  ,
    label: 'Tax:'
    prop: 'tax'
  ,
    label: 'Discount:'
    prop: 'discount'
  ,
    label: 'Gift card:'
    prop: 'gift_card'
  ,
    label: 'Shipping:'
    prop: 'shipping'
  ,
    label: 'Total:'
    prop: 'total'
  ]

  getDisplayPrice: (row) ->
    # Iff it's available, prefer @props.balance_cents over @props.total_cents
    centValue = if row.prop is 'total' and _.isFinite(@props.balance_cents)
        @props.balance_cents
      else
        @props["#{row.prop}_cents"]
    displayPrice = "$#{@convert 'cents', 'dollars', centValue}"

    if row.prop in ['discount', 'gift_card']
      displayPrice = "- #{displayPrice}"

    if row.prop is 'shipping' and centValue is 0
      displayPrice = 'Free'

    displayPrice

  getTableRow: (row, i) ->
    cellClass = "u-reset u-fs16 u-mb24
      #{['u-fws' if row.prop is 'total']}"

    return null if not @props["#{row.prop}_cents"] and row.prop in ['discount', 'gift_card']

    <tr key=i>
      <th className="#{@BLOCK_CLASS}__header #{cellClass}"
        children=row.label />
      <td className="#{@BLOCK_CLASS}__cell #{cellClass}"
        children=@getDisplayPrice(row) />
    </tr>

  render: ->
    <table className="#{@BLOCK_CLASS} #{@props.cssModifier}">
      {_.compact _.map(@rows, @getTableRow)}
    </table>
