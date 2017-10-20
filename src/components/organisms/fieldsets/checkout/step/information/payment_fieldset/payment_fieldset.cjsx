[
  _
  React

  FormGroupCardDetails
  FormGroupPromoCode
  FormGroupListBox
  ListBoxOptionDefault
  ListBoxOptionPayment

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/card_details/card_details'
  require 'components/organisms/formgroups/promo_code/promo_code'
  require 'components/molecules/formgroup/listbox/listbox'
  require 'components/atoms/forms/listbox_options/default/default'
  require 'components/atoms/forms/listbox_options/payment/payment'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-payment-fieldset'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.creditCard
    Mixins.dispatcher
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    paymentErrors: React.PropTypes.object
    promo_codes: React.PropTypes.array
    gift_cards: React.PropTypes.array
    discountError: React.PropTypes.object
    htoMessage: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    paymentErrors: {}
    savedPayments: []
    promo_codes: []
    gift_cards: []
    discountError: {}
    htoMessage: '
      We require a valid credit or debit card for your order, but not
      to worry—the trial is free! You won’t be charged unless you
      don’t return the frames. (You may see a temporary authorization
      charge, but that’s just to make sure you’re, you know, not a robot.)
    '

  getInitialState: ->
    # Show credit card inputs if we have no saved payments
    newPayment: _.isEmpty(@props.savedPayments) or
      # Or if we have payment data that's not saved
      (_.get(@props, 'paymentData.cc_last_four') and not _.get(@props, 'paymentData.cc_id'))

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
    "
    legend:
      'u-reset u-fs20 u-ffs u-fws u-mb24'
    checkboxLabel:
      '-inline'
    checkboxDataItem:
      'c-formgroup__data-item'
    notice: '
      u-mb12 u-mtn6
      u-ffss u-fs14
      u-color--dark-gray-alt-2
    '

  classesWillUpdate: ->
    promo:
      'u-mtn24': not @props.cc_required

  handleBlurInput: (evt) ->
    @commandDispatcher 'estimate', 'validateInformation', 'payment',
      @formatCreditCardEvent(evt)

  handleChangeInput: (attrs) ->
    @commandDispatcher 'estimate', 'validateInformation', 'payment', attrs

  managePaymentListboxChange: (value) ->
    @setState newPayment: value is 'new'

    @commandDispatcher 'estimate', 'clearInformation', 'payment'

    if value isnt 'new'
      paymentData = _.find @props.savedPayments, cc_id: value
      @commandDispatcher 'estimate', 'validateInformation', 'payment', paymentData
    else if _.get @props, 'paymentData.address_zip'
      @commandDispatcher 'estimate', 'validateInformation', 'payment',
        address_zip: @props.paymentData.address_zip

  manageApplyDiscount: (code) ->
    @commandDispatcher 'estimate', 'applyDiscount', code

  manageRemoveDiscount: (code) ->
    @commandDispatcher 'estimate', 'removeDiscount', code

  getCardProps: ->
    card = @props.paymentData
    if _.isEmpty card
      {}
    else
      expiration: [
        card.cc_expires_month
        _.get(card, 'cc_expires_year', '').slice 2
      ].join '/'
      number: card.cc_number
      cvv: card.cc_cvv
      address_zip: card.address_zip

  getCardErrors: ->
    errors =
      number:      @props.paymentErrors.number or _.get @props, 'errors.payment.cc_number'
      expiration:  @props.paymentErrors.exp_year or @props.paymentErrors.exp_month or
                   _.get @props, 'errors.payment.cc_expires_year'
      cvv:         @props.paymentErrors.cvc or _.get @props, 'errors.payment.cc_cvv'
      address_zip: _.get @props, 'errors.payment.address_zip'

    _.omitBy errors, _.isUndefined

  getFocusedIndex: ->
    if _.get @props, 'paymentData'
      # Use a payment saved on the estimate if present.
      id = _.get @props, 'paymentData.cc_id'
      if id
        # If the payment is also saved on the account, get its index by its id.
        _.findIndex @props.savedPayments, (payment) ->
          "#{payment.cc_id}" is id.toString()
      else
        # Otherwise, this is a new payment, so focus on the last 'new' option.
        @props.savedPayments.length

    else
      # No saved payments available, to default to the first payment.
      0

  getPaymentOptions: ->
    (_.map @props.savedPayments, (payment) ->
      data: _.assign payment, id: payment.cc_id
      component: ListBoxOptionPayment
    ).concat(
      data:
        id: 'new'
        label: 'Add a new payment'
      component: ListBoxOptionDefault
    )

  render: ->
    classes = @getClasses()
    legendId = "#{@BLOCK_CLASS}__legend"

    legendText =
      if @props.savedPayments.length
        if @props.is_hto_only then 'Choose a card to authorize your order:'
        else 'Choose a payment method:'
      else
        if @props.is_hto_only then 'Your card info'
        else 'Bill to'
    detailsLabel =
      if @props.is_hto_only then 'This is just for validation :-)' else 'Card Details'

    <fieldset className=classes.block>
      {if @props.cc_required
        [
          <legend
            key='legend'
            className=classes.legend
            id=legendId
            children=legendText />

          if @props.savedPayments.length
            <FormGroupListBox
              key='payment'
              name='payment'
              labelId=legendId
              options=@getPaymentOptions()
              focusedIndex=@getFocusedIndex()
              onChange=@managePaymentListboxChange />

          if @state.newPayment
            <FormGroupCardDetails
              {...@getCardProps()}
              key='credit_card'
              onChange=@handleChangeInput
              onBlur=@handleBlurInput
              errors=@getCardErrors()
              fieldLabel=detailsLabel
              validatedFields={_.get @props, 'validatedFields.payment', {}} />
        ]}

      {if @props.is_hto_only
        <p className=classes.notice children=@props.htoMessage />
      else
        <FormGroupPromoCode
          key='promo_code'
          cssModifier=classes.promo
          codes={[].concat @props.promo_codes, @props.gift_cards}
          txtError={_.get @props.discountError, 'generic', ''}
          manageApply=@manageApplyDiscount
          manageRemove=@manageRemoveDiscount />}

    </fieldset>
