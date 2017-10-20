[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  Prescription

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/molecules/prescription/prescription'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-prescription-show'

  statics:
    route: ->
      path: '/account/prescriptions/{prescription_id}'
      handler: 'AccountPrescriptions'
      bundle: 'customer-center'
      title: 'Prescriptions'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  receiveStoreChanges: -> [
    'account'
  ]

  render: ->
    account = @getStore('account')
    prescriptions = account.prescriptions or []

    if account.__fetched
      prescriptionId = parseInt(@getRouteParams().prescription_id)
      prescription = @findObjectOr404 prescriptions, id: prescriptionId
    else
      prescription = null

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Prescriptions', href: '/account/prescriptions' }
      { text: "#{prescriptionId}"}
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props}>
        <div className={"#{@BLOCK_CLASS}"}>
          {if account.__fetched
            <Prescription {...prescription} />}
        </div>
      </Container>
    </LayoutDefault>
