[
  _
  React

  CheckoutSummary
  FormGroupText
  FormGroupSelect
  FormGroupPhoneNumber
  Form
  CTA
  Tooltip

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/organisms/formgroups/text_v2/text_v2'
  require 'components/organisms/formgroups/select/select'
  require 'components/organisms/formgroups/phone_number/phone_number'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/tooltip/tooltip'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-call-doctor-form'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
    React.addons.LinkedStateMixin
  ]

  receiveStoreChanges: -> [
    'regions'
  ]

  getDefaultProps: ->
    prescriptionErrors: {}
    prescriptionCallDoctorComplete: false

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heading:
      'u-fws u-ffs u-fs20 u-mt0 u-mb12'
    subHeading:
      'u-fs14 u-color--dark-gray-alt-3'
    cta:
      '-cta-full -cta-large'
    fields:
      'u-pb12'
    textInput:
      'inspectletIgnore'

  getInitialState: ->
    prescription = _.get @props, 'prescriptions[0].attributes', {}

    provider_name: prescription.provider_name or ''
    provider_phone: prescription.provider_phone or ''
    patient_name: prescription.patient_name or ''
    patient_birth_date_formatted: prescription.patient_birth_date_formatted or ''
    region: prescription.region or ''

  handleSubmit: (evt) ->
    evt.preventDefault()
    unless @props.prescriptionCallDoctorComplete
      # If form is incomplete, trigger errors and scroll to top
      @commandDispatcher 'estimate', 'validateModelForm', 'prescriptionCallDoctor'
      @commandDispatcher 'scrolling', 'scrollTo', 0
    else
      @commandDispatcher 'estimate', 'savePrescription',
        __modelName: 'prescriptionCallDoctor'
        __navigate: true
        attributes:
          provider_name: @state.provider_name
          provider_phone: @state.provider_phone
          patient_name: @state.patient_name
          patient_birth_date_formatted: @state.patient_birth_date_formatted
          region: @state.region

  formatNumber: (str, format='1982-09-21') ->
    # Remove non-numbers and truncate
    # to maximum digit length
    digits = str.replace(/\D/g, '').substr(0, format.replace(/\D/g, '').length)

    # Add in spacers, default with empty string.
    _.reduce digits, (result, digit, i) ->
      # If format has spacer, add that before next number.
      if format[result.length] and isNaN(parseInt(format[result.length]))
        result += format[result.length]
      result += digit
    , ''

  handleChangeDate: (evt) ->
    @setState patient_birth_date_formatted:
      @formatNumber(evt.target.value, '09-10-1982')

  handleChangePhone: (evt) ->
    @setState provider_phone: @formatNumber(evt.target.value, '555-555-5555')

  handleBlur: (field) ->
    _.bind (evt) ->
      @validateFields "attributes.#{field}": evt.target.value
    , @

  validateFields: (attrs) ->
    @commandDispatcher 'estimate', 'validateInformation', 'prescriptionCallDoctor', attrs

  render: ->
    classes = @getClasses()
    regions = @getStore('regions')
    analyticsSlug = 'callDoctor-click-submit'

    inputErrors = _.get @props, 'errors.prescriptionCallDoctor.attributes', {}

    formErrors = _.get @props.prescriptionErrors, 'attributes', {}

    validatedFields = _.get @props, 'validatedFields.prescriptionCallDoctor.attributes', {}

    <Form className=classes.block
      onSubmit=@handleSubmit
      validationErrors=formErrors>

      <h1 className=classes.heading
        children='Have us call your doctor' />

      {if @props.prescriptionErrors?.generic
        <Error children={@props.prescriptionErrors.generic} />}

      <p className=classes.subHeading
        children='Enter in your eye doctor’s information, and we’ll reach out
          to obtain your prescription information.' />

      <div className=classes.fields>
        <FormGroupText
          txtError=inputErrors.patient_name
          txtLabel='Patient’s full name'
          txtPlaceholder='Patient’s full name'
          cssModifierField=classes.textInput
          isValid=validatedFields.patient_name
          onBlur=@handleBlur('patient_name')
          valueLink=@linkState('patient_name') />

        <FormGroupText
          txtError=inputErrors.patient_birth_date_formatted
          txtLabel='Patient’s date of birth'
          placeholder='MM-DD-YYYY'
          pattern='[0-9]*'
          type='tel'
          cssModifierField=classes.textInput
          isValid=validatedFields.patient_birth_date_formatted
          onChange=@handleChangeDate
          onBlur=@handleBlur('patient_birth_date_formatted')
          valueLink=@linkState('patient_birth_date_formatted') />

        <p className=classes.subHeading>
          Why do we ask for this?
          <Tooltip children='Having your date of birth on file helps us obtain
            your prescription as quickly as possible, and allows doctors to look
            up prescription information or verify a patient’s identity.'
            version=2 />
        </p>

        <FormGroupText
          txtError=inputErrors.provider_name
          txtLabel='Doctor or clinic name'
          txtPlaceholder='Doctor or clinic name'
          isValid=validatedFields.provider_name
          cssModifierField=classes.textInput
          onBlur=@handleBlur('provider_name')
          valueLink=@linkState('provider_name') />

        <FormGroupPhoneNumber
          name='telephone'
          txtLabel='Doctor or clinic phone'
          txtPlaceholder='XXX-XXX-XXXX'
          txtError=inputErrors.provider_phone
          isValid=validatedFields.provider_phone
          onBlur=@handleBlur('provider_phone')
          valueLink=@linkState('provider_phone') />

        {if regions.__fetched
          <FormGroupSelect
            options=regions.regionOptGroups
            txtError=inputErrors.region
            txtLabel='Doctor or clinic state'
            isValid=validatedFields.region
            valueLink=@linkState('region')
            onChange=@handleBlur('region')
            version=2 />}
      </div>

      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        ctaCopy='Let us call your doctor'
        disabled={not @props.prescriptionCallDoctorComplete}
        analyticsSlug=analyticsSlug />

    </Form>
