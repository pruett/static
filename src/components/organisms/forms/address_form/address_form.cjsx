[
  _
  React

  FormGroupText
  FormGroupCheckbox
  FormGroupAddress
  FormGroupSelect
  CTA
  Places
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text/text'
  require 'components/organisms/formgroups/checkbox/checkbox'
  require 'components/organisms/formgroups/address/address'
  require 'components/organisms/formgroups/select/select'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/places/places'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-address-form'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.localization
    React.addons.LinkedStateMixin
  ]

  receiveStoreChanges: -> [
    'regions'
  ]

  propTypes:
    restrictToLocale: React.PropTypes.bool

    regions: React.PropTypes.shape
      regionOptGroups: React.PropTypes.array
      countryOptions: React.PropTypes.array

    address: React.PropTypes.shape(
      company: React.PropTypes.string
      country_code: React.PropTypes.string
      extended_address: React.PropTypes.string
      first_name: React.PropTypes.string
      id: React.PropTypes.number
      last_name: React.PropTypes.string
      locality: React.PropTypes.string
      middle_name: React.PropTypes.string
      postal_code: React.PropTypes.string
      region: React.PropTypes.string
      street_address: React.PropTypes.string
      telephone: React.PropTypes.string
    )

    addressErrors: React.PropTypes.shape(
      generic: React.PropTypes.string
      company: React.PropTypes.string
      country_code: React.PropTypes.string
      extended_address: React.PropTypes.string
      first_name: React.PropTypes.string
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
    restrictToLocale: true
    address:
      company: ''
      country_code: ''
      extended_address: ''
      first_name: ''
      last_name: ''
      locality: ''
      middle_name: ''
      postal_code: ''
      region: ''
      street_address: ''
      telephone: ''
    addressErrors:
      generic: ''
      company: ''
      country_code: ''
      extended_address: ''
      first_name: ''
      last_name: ''
      locality: ''
      middle_name: ''
      postal_code: ''
      region: ''
      street_address: ''
      telephone: ''

  getInitialState: ->
    company:          @props.address.company or ''
    country_code:     @props.address.country_code or @getLocale('country')
    extended_address: @props.address.extended_address or ''
    first_name:       @props.address.first_name or ''
    id:               @props.address.id
    last_name:        @props.address.last_name or ''
    locality:         @props.address.locality or ''
    middle_name:      @props.address.middle_name or ''
    postal_code:      @props.address.postal_code or ''
    region:           @props.address.region or ''
    street_address:   @props.address.street_address or ''
    telephone:        @props.address.telephone or ''

  handleAddressLookupSuccess: (address) ->
    @setState address

  setFormGroupProps: (result, label, key) ->
    country = @state.country_code

    result[key] =
      isError: Boolean(@props.addressErrors[key])
      name: key
      onFocus: @handleFocus
      txtError: @props.addressErrors[key]
      txtLabel: @localize "labels.#{key}", country
      valueLink: @linkState key

    regions = @getStore('regions')

    if regions.__fetched
      if key is 'region'
        _.assign result[key],
          options: regions.locales[country].regionOptGroups

      else if key is 'country_code'
        source = regions

        if @props.restrictToLocale
          source = source.locales[country]

        _.assign result[key], options: source.countryOptions

    result

  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.onSubmit(evt) if _.isFunction(@props.onSubmit)
    @props.manageSubmit(@state) if _.isFunction(@props.manageSubmit)

  render: ->
    regions = @getStore('regions')

    propsFormGroups = _.transform @localize('labels'), @setFormGroupProps

    <Form id='address-edit'
      autoComplete='off'
      method='post'
      validationErrors=@props.addressErrors
      className="#{@BLOCK_CLASS}"
      onSubmit={@handleSubmit}>

      <FormGroupText {...propsFormGroups.first_name} />
      <FormGroupText {...propsFormGroups.last_name}  />

      <FormGroupAddress {...propsFormGroups.street_address}
        onSuccess=@handleAddressLookupSuccess />

      <FormGroupText {...propsFormGroups.extended_address}
        ref='extended_address'
        txtSuperLabel='Optional' cssModifier='-half' />

      <FormGroupText {...propsFormGroups.company}
        txtSuperLabel='Optional' cssModifier='-half' />

      <FormGroupText {...propsFormGroups.locality} />

      {if regions.__fetched
        <FormGroupSelect {...propsFormGroups.region} />}

      <FormGroupText {...propsFormGroups.postal_code} />

      {if regions.__fetched
        <FormGroupSelect {...propsFormGroups.country_code}
          showBlankOption=false />}

      <FormGroupText type='tel'
        autoComplete='tel'
        {...propsFormGroups.telephone} />

      <CTA {...@props}
        analyticsSlug='address-click-save'
        variation='primary'
        children='Save Address'
        cssModifier='-cta-full' />

      {if @props.addressErrors?.generic
        <Error children={@props.addressErrors.generic} />}
    </Form>
