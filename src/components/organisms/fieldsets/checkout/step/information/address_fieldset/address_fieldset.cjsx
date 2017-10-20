[
  _
  React

  FormGroupText
  FormGroupSelect
  FormGroupAddress
  FormGroupCheckbox
  FormGroupPhoneNumber
  FormGroupPostalCode
  FieldError
  FormGroupListBox
  Error
  ListBoxOptionDefault
  ListBoxOptionAddress
  Tooltip

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text_v2/text_v2'
  require 'components/organisms/formgroups/select/select'
  require 'components/organisms/formgroups/address/address'
  require 'components/organisms/formgroups/checkbox/checkbox'
  require 'components/organisms/formgroups/phone_number/phone_number'
  require 'components/organisms/formgroups/postal_code/postal_code'
  require 'components/molecules/formgroup/error_v2/error_v2'
  require 'components/molecules/formgroup/listbox/listbox'
  require 'components/atoms/forms/error/error'
  require 'components/atoms/forms/listbox_options/default/default'
  require 'components/atoms/forms/listbox_options/address/address'
  require 'components/atoms/tooltip/tooltip'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-address-fieldset'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
    Mixins.localization
    React.addons.LinkedStateMixin
  ]

  propTypes:
    customer: React.PropTypes.object
    addresses: React.PropTypes.array
    addressErrors: React.PropTypes.object
    cssModifier: React.PropTypes.string
    useExpeditedShipping: React.PropTypes.bool
    costExpedited: React.PropTypes.string

  getDefaultProps: ->
    customer: {}
    addresses: []
    savedAddresses: []
    addressErrors: {}
    cssModifier: ''
    useExpeditedShipping: false
    costExpedited: 0

  getInitialState: ->
    customer = @props.customer
    # Use address on the estimate if available, otherwise default to saved.
    address = _.get @props, 'addresses[0]', _.get(@props, 'savedAddresses[0]', {})

    first_name:       address.first_name or customer.first_name or ''
    last_name:        address.last_name or customer.last_name or ''
    full_name:        address.full_name or customer.full_name or ''
    company:          address.company or ''
    country_code:     address.country_code or @getLocale('country')
    extended_address: address.extended_address or ''
    locality:         address.locality or ''
    postal_code:      address.postal_code or ''
    region:           address.region or ''
    street_address:   address.street_address or ''
    telephone:        address.telephone or ''
    useExpeditedShipping: @props.useExpeditedShipping

    didFillCustomerName: false

    newAddress: _.isEmpty(address) or
      (_.get(@props, 'addresses[0]', false) and not _.get(@props, 'addresses[0].existing_address_id', false))

  addressFields: [
    'existing_address_id'
    'full_name'
    'company'
    'extended_address'
    'locality'
    'postal_code'
    'region'
    'street_address'
    'telephone'
  ]

  componentWillReceiveProps: (props) ->
    # Autofill address name from customer name, but only once
    if not @state.didFillCustomerName and
    _.get props, 'validatedFields.customer.full_name', false
      @setState
        didFillCustomerName: true
        full_name: props.customer.full_name
      @validateFields full_name: props.customer.full_name

  receiveStoreChanges: -> [
    'regions'
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-fieldset-reset
      -bordered
    "
    legend:
      'u-reset u-fs20 u-ffs u-fws u-mb24'
    checkbox:
      'u-fs14 u-color--dark-gray-alt-2'
    checkboxLabel:
      '-inline u-pt2'
    checkboxDataItem:
      'c-formgroup__data-item'
    error:
      'u-mtn18 u-mb18'
    textInput:
      'inspectletIgnore'

  classesWillUpdate: ->
    checkboxDataItem:
      '-checked': @state.useExpeditedShipping
    addressInputs:
      'u-hide--visual': _.isEmpty @state.street_address

  manageAddressLookupSuccess: (address) ->
    @setState address
    @validateFields address

  manageAddressListboxChange: (value) ->
    @setState newAddress: value is 'new'

    @commandDispatcher 'estimate', 'clearInformation', 'address'

    @commandDispatcher 'scrolling', 'scrollTo', 0

    _.forEach @addressFields, (field) =>
      @linkState(field).requestChange ''

    if value isnt 'new'
      existingAddress = _.find @props.savedAddresses, id: value

      @commandDispatcher 'estimate', 'validateInformation', 'address',
        _.assign(existingAddress, existing_address_id: value)
    else
      @commandDispatcher 'estimate', 'validateInformation', 'address',
        country_code: @state.country_code

  handleChangeInput: (field) ->
    _.bind (evt) ->
      if evt.target isnt document.activeElement
        @validateFields "#{field}": evt.target.value
    , @

  validateFields: (attrs) ->
    @commandDispatcher 'estimate', 'validateInformation', 'address', attrs

  handleChangeExpedited: ->
    useExpeditedShipping = not @state.useExpeditedShipping
    @setState useExpeditedShipping: useExpeditedShipping
    @commandDispatcher 'estimate', 'updateShipping', useExpeditedShipping

  getLabel: (field) ->
    @localize "labels.#{field}", @getLocale('country')

  getErrorText: ->
    errors = _.get @props, 'errors.address', {}
    errors = _.pick errors, ['locality', 'region', 'postal_code']
    if _.size(errors) > 1
      'Mind checking your address real quick?'
    else if _.size(errors) is 1
      _.values(errors)[0]
    else
      ''

  getFocusedIndex: ->
    if _.get @props, 'addresses[0]'
      # Use an address saved on the estimate if present.
      id = _.get @props, 'addresses[0].existing_address_id'
      if id
        # If the address is also saved on the account, get its index by its id.
        _.findIndex @props.savedAddresses, id: id
      else
        # Otherwise, this is a new address, so focus on the last 'new' option.
        @props.savedAddresses.length

    else
      # No saved addresses available, to default to the first address.
      0

  getAddressOptions: ->
    (_.map @props.savedAddresses, (address) ->
      data: address
      component: ListBoxOptionAddress
    ).concat(
      data:
        id: 'new'
        label: 'Add a new address'
      component: ListBoxOptionDefault
    )

  getToolTipCopy: ->
    expeditedDeliveryDate = _.get @props, 'shipping_methods.expedited.est_arrival', 'N/A'
    expeditedDeliveryTimeInDays = _.get @props, 'shipping_methods.expedited.lead_time_num_days', '10'

    copy =
      nonRx: "
        Orders placed before 1 p.m. EST will be delivered
        by end of day #{expeditedDeliveryDate}
      "
      rx: "
        As soon as we have your prescription information,
        you can expect your frames within #{expeditedDeliveryTimeInDays}
        business days
      "

    if @props.prescription_required then copy.rx else copy.nonRx

  getLegendText: ->
    if @props.shipping_required
      if @props.savedAddresses.length
        'Choose a shipping address:'
      else
        'Ship to'
    else
      if @props.savedAddresses.length
        'Choose a billing address:'
      else
        'Billing details'

  render: ->
    classes = @getClasses()
    regions = @getStore 'regions'
    legendId = "#{@BLOCK_CLASS}__legend"

    <fieldset className=classes.block>
      <legend
        key='legend'
        className=classes.legend
        id=legendId
        children=@getLegendText() />

      {if @props.addressErrors.generic
        <Error children=@props.addressErrors.generic
          cssModifier='u-mb24' />}

      {if @props.savedAddresses.length
        <FormGroupListBox
          key='address'
          name='address'
          options=@getAddressOptions()
          focusedIndex=@getFocusedIndex()
          labelId=legendId
          onChange=@manageAddressListboxChange />}

      {if @state.newAddress
        <div>
          <FormGroupText
            key='name'
            txtLabel='First and Last Name'
            txtPlaceholder='First and Last Name'
            name='address_full_name'
            txtError={_.get @props, 'errors.address.full_name'}
            isValid={_.get @props, 'validatedFields.address.full_name', false}
            valueLink=@linkState('full_name')
            cssModifierField=classes.textInput
            onChange={@handleChangeInput('full_name')}
            onBlur={@handleChangeInput('full_name')} />

          <FormGroupAddress
            key='street_address'
            txtLabel=@getLabel('street_address')
            placeholder=@getLabel('street_address')
            name='street_address'
            txtError={_.get @props, 'errors.address.street_address'}
            validatedFields={_.get @props, 'validatedFields.address', {}}
            valueLink=@linkState('street_address')
            onChange={@handleChangeInput('street_address')}
            onBlur={@handleChangeInput('street_address')}
            onSuccess=@manageAddressLookupSuccess
            version=2 />

          <div className=classes.addressInputs>
            <div>
              <FormGroupText
                key='apt'
                txtPlaceholder=@getLabel('extended_address')
                name='extended_address'
                valueLink=@linkState('extended_address')
                onChange={@handleChangeInput('extended_address')}
                onBlur={@handleChangeInput('extended_address')}
                cssModifierField=classes.textInput
                cssModifier='u-w6c -inline' />

              <FormGroupText
                key='company'
                txtPlaceholder=@getLabel('company')
                name='company'
                valueLink=@linkState('company')
                onChange={@handleChangeInput('company')}
                onBlur={@handleChangeInput('company')}
                cssModifierField=classes.textInput
                cssModifier='u-w6c -inline' />
            </div>

            <div>
              <FormGroupText
                key='locality'
                txtLabel=@getLabel('locality')
                txtPlaceholder=@getLabel('locality')
                name='locality'
                txtError={_.get @props, 'errors.address.locality'}
                validation=false
                showErrorText=false
                valueLink=@linkState('locality')
                onChange={@handleChangeInput('locality')}
                onBlur={@handleChangeInput('locality')}
                cssModifierField=classes.textInput
                cssModifier='u-w5c -inline' />

              <FormGroupSelect
                key='region'
                txtLabel=@getLabel('region')
                name='region'
                txtError={_.get @props, 'errors.address.region'}
                showErrorText=false
                valueLink=@linkState('region')
                onChange={@handleChangeInput('region')}
                onBlur={@handleChangeInput('region')}
                options={_.get regions, "locales[#{@getLocale 'country'}].regionOptGroups"}
                cssModifier='u-w3c -inline'
                version={2}
                valueOnly={true} />

              <FormGroupPostalCode
                key='postal_code'
                txtLabel=@getLabel('postal_code')
                txtPlaceholder=@getLabel('postal_code')
                name='postal_code'
                txtError={_.get @props, 'errors.address.postal_code'}
                validation=false
                showErrorText=false
                valueLink=@linkState('postal_code')
                onChange={@handleChangeInput('postal_code')}
                onBlur={@handleChangeInput('postal_code')}
                cssModifierField=classes.textInput
                cssModifier='u-w4c -inline' />
            </div>

            <FieldError cssModifier=classes.error txtError={@getErrorText()} />

            {if _.get(regions, "locales[#{@getLocale 'country'}].countryOptions", []).length > 1
              <FormGroupSelect
                key='country'
                txtLabel=@getLabel('country_code')
                name='country_code'
                showBlankOption=false
                txtError={_.get @props, 'errors.address.country_code'}
                value=@getLocale('country')
                onChange={@handleChangeInput('country_code')}
                onBlur={@handleChangeInput('country_code')}
                options={_.get regions, "locales[#{@getLocale 'country'}].countryOptions"}
                version={2} />}

            {if @props.is_authenticated and not @props.is_nameless_user
              <FormGroupPhoneNumber
                key='telephone'
                name='telephone'
                txtLabel=@getLabel('telephone')
                txtPlaceholder=@getLabel('telephone')
                txtError={_.get @props, 'errors.address.telephone'}
                isValid={_.get @props, 'validatedFields.address.telephone', false}
                valueLink=@linkState('telephone')
                onChange={@handleChangeInput('telephone')}
                onBlur={@handleChangeInput('telephone')}
                showSmsCheckbox={_.get(@props, 'customer.sms_opt_in', null) is null}
                isVisible={!_.isEmpty @state.street_address} />}
          </div>
        </div>}


      {if @props.is_expedited_shipping_available
        <FormGroupCheckbox
          key='useExpeditedShipping'
          txtLabel='Expedited shipping'
          name='useExpeditedShipping'
          cssModifier=classes.checkbox
          cssLabelModifier=classes.checkboxLabel
          cssModifierBox='-border-light-gray'
          checked=@state.useExpeditedShipping
          onChange=@handleChangeExpedited>

          <Tooltip
            version={2}
            analyticsSlug='expeditedShipping-click-tooltip'
            children={@getToolTipCopy()} />

          <span className=classes.checkboxDataItem
            children=@props.costExpedited />
        </FormGroupCheckbox>}
    </fieldset>
