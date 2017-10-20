[
  _
  React

  CTA
  Error
  TermsAndConditions
  Tooltip
  FormGroupCheckbox
  FormGroupText

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/forms/error/error'
  require 'components/atoms/terms_and_conditions/terms_and_conditions'
  require 'components/atoms/tooltip/tooltip'
  require 'components/organisms/formgroups/checkbox/checkbox'
  require 'components/organisms/formgroups/text_v2/text_v2'

  require 'components/mixins/mixins'

  require './customer.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-customer'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  propTypes:
    appointment: React.PropTypes.object
    cssModifier: React.PropTypes.string
    customer: React.PropTypes.object
    isVisible: React.PropTypes.bool
    manageCustomerBook: React.PropTypes.func

  getDefaultProps: ->
    cssModifier: ''
    customer: {}
    isVisible: true

  getInitialState: ->
    telephone: ''
    over_eighteen: false

  componentDidUpdate: (prevProps) ->
    return unless @customerIsBookingChanged prevProps, @props

    if _.get @props, 'appointment.customer_is_booking'
      # Customer is booking for his/herself, so use customer data.
      customer = @props.customer or {}

      @setState(
        email: customer.email or ''
        first_name: customer.first_name or ''
        last_name: customer.last_name or ''
        telephone: ''
      )

    else
      # Customer is booking for someone else, so clear any customer data.
      @setState(
        email: ''
        first_name: ''
        last_name: ''
        telephone: ''
      )

  customerIsBookingChanged: (prevProps, nextProps) ->
    prevCustomerIsBooking = _.get prevProps, 'appointment.customer_is_booking'
    nextCustomerIsBooking = _.get nextProps, 'appointment.customer_is_booking'

    prevCustomerIsBooking isnt nextCustomerIsBooking

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
      u-grid__row -center"
    inputs:
      'u-grid__col u-w12c -c-8--600 -c-6--900
      u-tal'
    legend:
      "#{@BLOCK_CLASS}__legend
      u-tac
      u-fs
      u-fs20 u-fs30--600 u-fs34--1200
      u-ffs
      u-fws
      u-mb24 u-mb48--600"
    ageContainer:
      'u-fs16'
    ageTooltip:
      "#{@BLOCK_CLASS}__age-tooltip"
    ageQuestion:
      'u-m0
      u-fs16
      u-fws'
    ageAnswer:
      'u-m0
      u-fs16'
    ageError:
      'u-mtn24 u-mb24'
    submit:
      '-cta-full
      u-fs16
      u-fws
      u-ffss'
    genericError:
      'u-fs16
      u-mt12 u-mb24
      u-color--yellow'
    termsAndConditions:
      'u-fs14 u-tac u-mt12 u-lh24'
    fieldContainer:
      "#{@BLOCK_CLASS}__field-container u-fs16"
    bullet:
      "#{@BLOCK_CLASS}__bullet u-mb12 u-ffss u-fs16 u-fs18--900 u-color--dark-gray-alt-3"
    toKnowHeader: "
      #{@BLOCK_CLASS}__to-know-header
      u-fs10 u-ttu u-ls2_5 u-color--light-gray-alt-6 u-m0 u-tac u-pr u-m0a
      u-color-bg--light-gray-alt-5
    "

  handleInputChange: (field, type = 'text') ->
    ((evt) ->
      value = switch type
        when 'checkbox'
          evt.target.checked
        else
          evt.target.value

      @setState "#{field}": value
    ).bind @

  handleCTAClick: (evt) ->
    evt.preventDefault()

    if _.isFunction @props.manageCustomerBook
      @props.manageCustomerBook _.pick(
        @state, 'email', 'first_name', 'last_name', 'telephone', 'over_eighteen'
      )

  getCopy: ->
    {service_key, customer_is_booking} = @props.appointment

    if service_key is 'photographer'
      legend: 'Great! Tell us about yourself.'
      labels:
        email: 'Email address'
        firstName: 'First name'
        lastName: 'Last name'
        telephone: 'Phone number'
        age: 'I am over 18 years of age'
        tooltip: 'Why do we ask if you are over 18?'

    else if service_key is 'optometrist' and not customer_is_booking
      legend: 'Great! We just need a few more details...'
      labels:
        email: 'Patient\'s email address'
        firstName: 'Patient\'s first name'
        lastName: 'Patient\'s last name'
        telephone: 'Patient\'s phone number'
        age: 'The patient is over 18 years of age'
        tooltip: 'Why do we ask if the patient is over 18?'

    else
      legend: 'Great! We just need a few more details...'
      labels:
        email: 'Email address'
        firstName: 'First name'
        lastName: 'Last name'
        telephone: 'Phone number'
        age: 'I am over 18 years of age'
        tooltip: 'Why do we ask if you are over 18?'

  eyeExamPriceByLocation: (location_slug) ->
    switch location_slug
      when "83-newbury-st" then "$105"
      else "$75"

  contactLensAvailability: (location_slug) ->
    switch location_slug
      when "83-newbury-st" then "We provide contact lens prescriptions and fittings"
      else "We aren't able to provide contact lens prescriptions or fittings"

  thingsToKnowCopy: (location_slug = '') ->
    heading: 'Things to know'
    bullets: [
      "Your exam will cost #{@eyeExamPriceByLocation(location_slug)} and last about 20 minutes",
      "#{@contactLensAvailability(location_slug)}",
      'Patients under 18 must bring a parent or legal guardian'
    ]

  render: ->
    appointment = @props.appointment or {}
    classes = @getClasses()
    copy = @getCopy()
    thingsToKnow = @thingsToKnowCopy(@props.appointment.location_slug)

    <fieldset className=classes.block>
      <legend
        children=copy.legend
        className=classes.legend />

      <div className=classes.inputs>
        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          onChange={@handleInputChange 'first_name'}
          txtError={_.get appointment, 'errors.first_name', ''}
          txtLabel=copy.labels.firstName
          value=@state.first_name />

        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          onChange={@handleInputChange 'last_name'}
          txtError={_.get appointment, 'errors.last_name', ''}
          txtLabel=copy.labels.lastName
          value=@state.last_name />

        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          onChange={@handleInputChange 'email'}
          txtError={_.get appointment, 'errors.email', ''}
          txtLabel=copy.labels.email
          type='email'
          value=@state.email />

        <FormGroupText
          cssModifierFieldContainer=classes.fieldContainer
          onChange={@handleInputChange 'telephone'}
          pattern='[0-9]*'
          txtError={_.get appointment, 'errors.telephone', ''}
          txtLabel=copy.labels.telephone
          type='tel'
          value=@state.telephone />

        <div className='u-pr u-bss u-bc--light-gray u-bw1 u-p24 u-mb48 u-mb36--900'>
          <h3 className=classes.toKnowHeader>{thingsToKnow.heading}</h3>
          <ul className='u-reset'>
            {thingsToKnow.bullets.map (x,i) ->
              <li className=classes.bullet key={i}>{x}</li>
            }
          </ul>
        </div>

        <CTA analyticsSlug='appointments-click-bookCustomer'
          children='Roger that. Book me!'
          cssModifier=classes.submit
          onClick=@handleCTAClick
          variation='primary' />

        {if _.get(appointment, 'service_key') is 'optometrist'
            <TermsAndConditions
              variation='appointment'
              cssModifier=classes.termsAndConditions />}

        {if _.get appointment, 'errors.generic'
          <Error children=appointment.errors.generic
            cssModifier=classes.genericError />
        }
      </div>
    </fieldset>
