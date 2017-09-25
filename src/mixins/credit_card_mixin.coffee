_ = require 'lodash'

module.exports =
  allCardData: [
    id: '1'
    name: 'American Express'
    firstDigit: '3'
    formatNumber: '3333 333333 33333'
    formatCVV: '1111'
  ,
    id: '2'
    name: 'Discover'
    firstDigit: '6'
    formatNumber: '6666 6666 6666 6666'
    formatCVV: '111'
  ,
    id: '3'
    name: 'MasterCard'
    firstDigit: '5'
    formatNumber: '5555 5555 5555 5555'
    formatCVV: '111'
  ,
    id: '4'
    name: 'Visa'
    firstDigit: '4'
    formatNumber: '4444 4444 4444 4444'
    formatCVV: '111'
  ,
    id: '99'
    name: 'Unknown'
    formatNumber: '1111 1111 1111 1111'
    formatCVV: '111'
  ]

  findCardWhere: (attrs) ->
    _.find @allCardData, attrs

  findCard: (attrs) ->
    card = _.find @allCardData, attrs
    if card then card else _.find @allCardData, name: 'Unknown'

  formatCreditCardData: (name, value) ->
    switch name
      when 'number'
        cc_number: value.replace /\D+/g, ''
        cc_last_four: value.substr -4
        cc_type_id: _.result(
          @findCardWhere firstDigit: value.substr(0, 1)
          'id'
        )

      when 'expiration'
        [month, year] = value.split '/'
        year = "20#{year}" if year

        cc_expires_month: month
        cc_expires_year: year

      when 'cvv'
        cc_cvv: value

      else
        (data = {})[name] = value
        data

  formatCreditCardEvent: (evt) ->
    @formatCreditCardData evt.target.name, evt.target.value
