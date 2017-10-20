React = require 'react/addons'

require './credit_card.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-credit-card-icon'

  IMAGE_FILES:
    'Unknown': 'unknown'
    'American Express': 'amex'
    'Amex': 'amex'
    'Diners': 'diners'
    'Discover': 'discover'
    'JCB': 'jcb'
    'MasterCard': 'mastercard'
    'MC': 'mastercard'
    'Visa': 'visa'

  propTypes:
    cardType: React.PropTypes.oneOf [
      'Unknown',
      'American Express',
      'Amex'
      'Diners',
      'Discover',
      'JCB',
      'MasterCard',
      'MC'
      'Visa'
    ]
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cardType: 'Unknown'
    cssUtility: ''
    cssModifier: ''
    isSquare: false

  render: ->
    filename = @IMAGE_FILES[@props.cardType]
    filename += '-square' if @props.isSquare
    filename += '.png'
    <img className="#{@BLOCK_CLASS} #{@props.cssUtility} #{@props.cssModifier}"
      src="/assets/img/icons/credit_cards/#{filename}" />
