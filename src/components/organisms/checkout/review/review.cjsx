[
  _
  React

  CheckoutSummary
  LineItem
  CreditCardIcon
  Address
  Error
  PrescriptionTable

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/molecules/checkout/line_item/line_item'
  require 'components/atoms/icons/credit_card/credit_card'
  require 'components/atoms/address_v2/address_v2'
  require 'components/atoms/forms/error/error'
  require 'components/atoms/tables/prescription_v2/prescription_v2'

  require 'components/mixins/mixins'

  require './review.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-review'

  mixins: [
    Mixins.classes
    Mixins.creditCard
    Mixins.dispatcher
  ]

  propTypes:
    totals: React.PropTypes.object
    items: React.PropTypes.array
    existingPrescription: React.PropTypes.object
    isHTOOnly: React.PropTypes.bool

  getDefaultProps: ->
    totals: {}
    items: []

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-clearfix
      u-mt48--900
    "
    columnLeft: '
      u-w12c u-w6c--900 u-fr--900
      u-pr72--900 u-pl60--900
      u-brss--900 u-bw1 u-bc--light-gray
      inspectlet-sensitive
    '
    columnRight: '
      u-w12c u-w6c--900 u-fr--900
      u-pl72--900 u-pr60--900
      u-mln1--900
      u-blss--900 u-bw1 u-bc--light-gray
    '
    section: "
      #{@BLOCK_CLASS}__section
      u-pr u-pb24 u-mt24
      u-bbss u-bw1 u-bc--light-gray
    "
    sectionHeading:
      'u-ffs u-fs20 u-fws u-mt0 u-mb12'
    sectionSubhead:
      'u-ffss u-fs16 u-fws u-m0'
    sectionDetail: '
      u-ffss u-fs16 u-m0
      u-color--dark-gray-alt-3
    '
    editTrigger:
      'u-pa u-t0 u-r0 u-fws'
    creditCardIcon: "
      #{@BLOCK_CLASS}__credit-card-icon
      u-pt4
    "
    creditCardDetail:
      'u-dib u-vat u-ffss u-fs16 u-m0 u-color--dark-gray-alt-3'
    bottomSummary:
      'u-dn--900 u-pt12'

  handleSubmitOrderClick: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'estimate', 'submitOrder'

  getExpDate: (data) ->
    month = _.get(data, 'cc_expires_month', '').toString()
    year = _.get(data, 'cc_expires_year', '').toString()

    if month.length is 1
      month = "0#{month}"
    year = year.substr(2, 2)

    [month, year].join '/'

  renderItemsSection: ->
    htoItems = _.filter @props.items, (item) -> item.variant_type is 'HTO'
    nonHtoItems = _.filter @props.items, (item) -> item.variant_type isnt 'HTO'

    multiColumn = nonHtoItems.length > 1 or (htoItems.length and nonHtoItems.length)

    <section>
      {if htoItems.length
        <LineItem
          key='hto'
          htoItems=htoItems
          multiColumn=multiColumn />}

      {_.map nonHtoItems, (item, i) ->
        <LineItem
          key=i
          item=item
          multiColumn=multiColumn />}
    </section>

  renderAddressSection: ->
    <section className=@classes.section>
      <h3 className=@classes.sectionHeading
        children="#{if @props.shipping_required then 'Shipping' else 'Billing'} address" />

      <a className=@classes.editTrigger
        href='/checkout/step/information'
        children='Edit' />

      <Address {...@props.addresses[0]} />
    </section>

  renderPaymentSection: ->
    data = _.get @props, 'paymentData', {}
    cardType = data.cc_type or _.get @findCardWhere(id: data.cc_type_id), 'name'
    error = _.get @props, 'orderErrors.generic'

    <section className=@classes.section>
      <h3 className=@classes.sectionHeading
        children='Payment method' />

      <a className=@classes.editTrigger
        href='/checkout/step/information'
        children='Edit' />

      {<Error children=error /> if error}

      {if data.cc_last_four
        <div>
          <CreditCardIcon cardType=cardType cssModifier=@classes.creditCardIcon />
          <p className=@classes.creditCardDetail>
            {"Ending in #{data.cc_last_four}"}
            <br />
            {"Expires #{@getExpDate(data)}"}
          </p>
        </div>}
    </section>

  renderPrescriptionSection: ->
    variantType = _.get @props, 'prescriptions[0].variant_type'
    attributes = _.get @props, 'prescriptions[0].attributes', {}

    return unless variantType

    subhead = switch variantType
      when 'non-rx' then 'Non-prescription glasses'
      when 'existing' then ''
      else _.upperFirst variantType.replace('-', ' ')

    <section className=@classes.section>
      <h3 className=@classes.sectionHeading
        children='Prescription' />

      <a className=@classes.editTrigger
        href='/checkout/step/prescription'
        children='Edit' />

      {<p className=@classes.sectionSubhead children=subhead /> if subhead}

      {switch variantType
        when 'existing'
          <PrescriptionTable prescription=@props.existingPrescription />
        when 'call-doctor'
          <div>
            <p className=@classes.sectionDetail children=attributes.provider_name />
            <p className=@classes.sectionDetail children=attributes.provider_phone />
          </div>
        when 'send-later'
          <p className=@classes.sectionDetail
            children='To send us your prescription, simply snap a photo
            and upload it to your account after checkout.' />
        when 'uploaded'
          <p className=@classes.sectionDetail children="File: #{attributes.name}" />
        when 'readers'
          <p className=@classes.sectionDetail
            children="Magnification strength:
            +#{parseFloat(attributes.readers_strength).toFixed(2)}" />}

    </section>

  renderSummarySection: ->
    <section>
      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        isFinal=true
        is_hto_only=@props.isHTOOnly
        minimal=true
        ctaCopy='Place order'
        analyticsSlug='checkout-click-placeOrder'
        onClick=@handleSubmitOrderClick />
    </section>

  renderBottomSummarySection: ->
    <section className=@classes.bottomSummary>
      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        isFinal=true
        is_hto_only=@props.isHTOOnly
        ctaCopy='Place order'
        analyticsSlug='checkout-click-placeOrderBottom'
        onClick=@handleSubmitOrderClick />
    </section>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>

      <div className=@classes.columnRight>
        {@renderItemsSection()}
        {@renderSummarySection()}
      </div>

      <div className=@classes.columnLeft>
        {@renderAddressSection() if _.size @props.addresses}

        {@renderPaymentSection() if @props.paymentData}

        {@renderPrescriptionSection() if _.get @props, 'prescriptions[0].variant_type'}
      </div>

      {@renderBottomSummarySection()}

    </div>

