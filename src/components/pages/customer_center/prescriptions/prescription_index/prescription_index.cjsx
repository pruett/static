[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  Step

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/atoms/buttons/step/step'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-prescription-index'

  statics:
    route: ->
      path: '/account/prescriptions'
      handler: 'AccountPrescriptions'
      bundle: 'customer-center'
      title: 'Prescriptions'

  mixins: [
    Mixins.context
    Mixins.conversion
    Mixins.dispatcher
  ]

  propTypes:
    prescriptions: React.PropTypes.arrayOf React.PropTypes.object

  receiveStoreChanges: -> [
    'account'
  ]

  getPrescriptionType: (prescription) ->
    if prescription.os_add and prescription.os_axis
      type = 'Progressives'
    else if prescription.os_add
      type = 'Readers'
    else
      type = 'Single-vision'

  getPrescription: (prescription) ->
    expires = @convert 'date', 'object', prescription.expiration_date
    daysSince = @convert 'date', 'days-since', prescription.expiration_date

    cssExpiration = [
      'u-reset u-color--dark-gray-alt-2' if daysSince > 0
    ].join ''

    <Step {...prescription}
      txtLabel={@getPrescriptionType(prescription)}
      route="/account/prescriptions/#{prescription.id}"
      key={prescription.id}>
      <span className=cssExpiration>
        Expires: {expires.month} {expires.date}, {expires.year}
      </span>
    </Step>

  render: ->
    account = @getStore('account')
    prescriptions = account.prescriptions or []
    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Prescriptions' }
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props}>
        {if account.__fetched
          <div className="#{@BLOCK_CLASS} u-mln6 u-mrn6">
            {_.map prescriptions, @getPrescription}
          </div>}
      </Container>
    </LayoutDefault>
