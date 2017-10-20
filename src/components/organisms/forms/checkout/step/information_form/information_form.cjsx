[
  _
  React

  CheckoutSummary
  AddressFieldset
  CustomerFieldset
  PaymentFieldset
  Form

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/organisms/fieldsets/checkout/step/information/address_fieldset/address_fieldset'
  require 'components/organisms/fieldsets/checkout/step/information/customer_fieldset/customer_fieldset'
  require 'components/organisms/fieldsets/checkout/step/information/payment_fieldset/payment_fieldset'
  require 'components/atoms/forms/form/form'

  require 'components/mixins/mixins'

  require './information_form.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-order-information-form'

  mixins: [
    Mixins.classes
    Mixins.conversion
    Mixins.dispatcher
  ]

  propTypes:
    addresses: React.PropTypes.array
    addressErrors: React.PropTypes.object
    customer: React.PropTypes.object
    customerErrors: React.PropTypes.object
    discountErrors: React.PropTypes.object
    gift_cards: React.PropTypes.array
    payments: React.PropTypes.array
    promo_codes: React.PropTypes.array
    promoCodeErrors: React.PropTypes.object
    savedAddresses: React.PropTypes.array
    savedPayments: React.PropTypes.array
    shipping: React.PropTypes.object

  getDefaultProps: ->
    addresses: []
    addressErrors: {}
    customer: {}
    customerErrors: {}
    discountErrors: {}
    gift_cards: []
    payments: []
    promo_codes: []
    promoCodeErrors: {}
    savedAddresses: []
    savedPayments: []
    shipping: {}
    totals:
      total_cents: 0

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    form: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
    "
    fieldset:
      "#{@BLOCK_CLASS}__fieldset"

  handleFormSubmit: (evt) ->
    evt.preventDefault()
    unless @props.informationStepComplete
      # If form is incomplete, trigger errors and scroll to top
      @commandDispatcher 'estimate', 'validateInformationForm'
      @commandDispatcher 'scrolling', 'scrollTo', 0
    else if @props.skipReview
      @commandDispatcher 'estimate', 'saveInformationAndSubmitOrder'
    else
      @commandDispatcher 'estimate', 'saveInformation'

  transformError: (result, value, key) ->
    _.assign result, _.omitBy(value, _.isEmpty)

  render: ->
    classes = @getClasses()

    ctaCopy = if @props.skipReview
      'Place order'
    else if @props.prescription_required
      'Add your prescription'
    else
      'Review'

    ctaSlug = if @props.skipReview
      'checkout-click-placeOrder'
    else
      'checkout-save-informationStep'

    # Get errors on a single object.
    errors = _.pickBy @props, (value, key) -> key.indexOf('Errors') isnt -1
    validationErrors = _.transform errors, @transformError, {}

    # Expedited Shipping
    centsExpedited = _.get(@props, 'shipping_methods.expedited.method_cost', 0)
    costExpedited = "$#{@convert 'cents', 'dollars', centsExpedited}"
    useExpeditedShipping = _.get(@props, 'shipping.method_id') is
      _.get(@props, 'shipping_methods.expedited.method_id')

    <div className=classes.block>
      <Form id='order-information-edit'
        name='createaccount'
        validationErrors=validationErrors
        method='post'
        className=classes.form
        onSubmit=@handleFormSubmit>

        {if @props.is_nameless_user or not @props.is_authenticated
          <CustomerFieldset
            {...@props}
            key='new-customer'
            cssModifier=classes.fieldset />}

        <AddressFieldset
          {...@props}
          key='new-address'
          cssModifier=classes.fieldset
          costExpedited=costExpedited
          useExpeditedShipping=useExpeditedShipping />

        <PaymentFieldset
          {...@props}
          key='new-payment'
          cssModifier=classes.fieldset />

        <CheckoutSummary
          is_hto_only=@props.is_hto_only
          totals=@props.totals
          itemCount={_.size(@props.items)}
          isFinal=@props.skipReview
          ctaCopy=ctaCopy
          disabled={not @props.informationStepComplete}
          analyticsSlug=ctaSlug />

      </Form>
    </div>
