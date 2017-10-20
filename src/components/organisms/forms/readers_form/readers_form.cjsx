[
  _
  React

  CheckoutSummary
  StrengthSelector
  Form
  Error

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/atoms/forms/strength_selector/strength_selector'
  require 'components/atoms/forms/form/form'
  require 'components/atoms/forms/error/error'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-readers-form'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
  ]

  getDefaultProps: ->
    totals: {}
    items: []

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    magnification:
      "#{@BLOCK_CLASS}__magnification u-mb48"
    heading: '
      u-ffs u-fws
      u-fs20 u-mr24 u-mr48--600
    '

  getInitialState: ->
    readers_strength: _.get @props,
      'prescriptions[0].attributes.readers_strength', ''

  handleSubmit: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'estimate', 'savePrescription',
      __modelName: 'prescriptionReaders'
      __navigate: true
      use_high_index: false
      attributes:
        readers_strength: @state.readers_strength

  handleChangeStrength: (evt) ->
    @setState readers_strength: evt.target.value

  render: ->
    classes = @getClasses()
    errors = _.get @props, 'prescriptionErrors', {}
    analyticsSlug = 'checkout-save-readers'

    <Form className=classes.block
      onSubmit=@handleSubmit
      validationErrors=errors>
      <div className=classes.magnification>
        <h1 className=classes.heading
          children='Choose the magnification strength for your reading
            glasses:' />

        {if errors.generic
          <Error children={errors.generic} />}

        <StrengthSelector onChange=@handleChangeStrength
          selected=@state.readers_strength />

        {if errors.attributes?.readers_strength
          <Error children={errors.attributes?.readers_strength} />}

      </div>


      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        ctaCopy='Next step: Review'
        disabled={not @state.readers_strength}
        analyticsSlug=analyticsSlug />

    </Form>
