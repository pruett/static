[
  React

  Confirm
  Address

  Mixins
] = [
  require 'react/addons'

  require 'components/molecules/modals/confirm/confirm'
  require 'components/atoms/address/address'

  require 'components/mixins/mixins'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-address-destroy'

  mixins: [
    Mixins.context
  ]

  propTypes:
    routeCancel: React.PropTypes.string
    handleClickDelete: React.PropTypes.func
    address: React.PropTypes.shape(
      company: React.PropTypes.string
      country_code: React.PropTypes.string
      extended_address: React.PropTypes.string
      first_name: React.PropTypes.string
      formatted_address: React.PropTypes.string
      id: React.PropTypes.number
      last_name: React.PropTypes.string
      locality: React.PropTypes.string
      middle_name: React.PropTypes.string
      postal_code: React.PropTypes.string
      region: React.PropTypes.string
      street_address: React.PropTypes.string
      telephone: React.PropTypes.string
    )

  getDefaultProps: ->
    routeCancel: ''
    handleClickDelete: ->

    address:
      company:           ''
      country_code:      ''
      extended_address:  ''
      first_name:        ''
      formatted_address: ''
      last_name:         ''
      locality:          ''
      postal_code:       ''
      region:            ''
      street_address:    ''
      telephone:         ''

  handleClickDelete: (evt) ->
    evt.preventDefault()
    @props.handleClickDelete(@props.address)

  render: ->
    <div className=@BLOCK_CLASS>
      <Confirm
        id='address-destroy'
        txtHeading='Are you sure you would like to delete this address?'
        txtConfirm='Yes, please delete it'
        txtCancel='Nevermind, keep it'
        routeCancel=@props.routeCancel
        onConfirm=@handleClickDelete>

        <Address {...@props.address} />

      </Confirm>
    </div>
