[
  _
  React

  CheckoutSummary
  LensChoice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/checkout/summary/summary'
  require 'components/atoms/buttons/lens_choice/lens_choice'

  require 'components/mixins/mixins'
]


COPY =
  header: 'Select your lenses'
  intro:  'All of our lenses come with anti-scratch, anti-reflective, and
           superhydrophobic lens coatings—plus provide 100% UV protection.'
  lensTypes: [
    type:    'poly'
    title:   'Polycarbonate lenses (Included)'
    details: 'Standard lenses that will work with most prescriptions'
  ,
    type:    'high_index_167'
    title:   '1.67 High Index Lenses'
    details: 'These lenses are designed for prescriptions with a combined sphere and cylinder
              of ±4.00 or higher—and they’re up to 40% thinner than standard lenses.'
  ]

module.exports = React.createClass
  BLOCK_CLASS: 'c-lens-type-form'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    totals: React.PropTypes.object

  getDefaultProps: ->
    totals: {}

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    form: '
      u-mb48
    '
    header: '
      u-fws u-ffs u-m0 u-fs20
    '
    intro: '
      u-fs14 u-lh20
      u-mt12 u-mb24
      u-color--dark-gray-alt-3
    '

  chooseLensType: (type, evt) ->
    @commandDispatcher 'estimate', 'savePrescription',
      __navigate: true
      use_high_index: type is 'high_index_167'

  getPrescriptionTypes: ->
    _.reduce @props.items, (result, item) ->
      attributes = _.get item, 'attributes.attributes', {}

      if attributes.frame_variant_type_id isnt 2 # Not non-rx
        if attributes.frame_assembly_type_id is 1
          result.optical = true
        else if attributes.frame_assembly_type_id is 2
          result.sun = true

      result

    , {optical: false, sun: false}

  getPriceText: (type) ->
    upcharges = _.get @props, "item_upcharges.frames.#{type}"
    rxTypes = @getPrescriptionTypes()

    if rxTypes.optical and rxTypes.sun
      [
        "Additional $#{upcharges.optical / 100} for Eyeglasses"
        "Additional $#{upcharges.sun / 100} for Sunglasses"
      ]
    else if rxTypes.optical
      ["Additional $#{upcharges.optical / 100}"]
    else if rxTypes.sun
      ["Additional $#{upcharges.sun / 100}"]
    else
      'Not Applicable'

  renderLensChoice: (lens) ->
    if lens.type isnt 'poly'
      subHead = @getPriceText lens.type
      highlight = _.get @props, 'prescriptions[0].use_high_index', false

    <LensChoice
      key=lens.type
      data-name=lens.type
      onClick={@chooseLensType.bind(@, lens.type)}
      title=lens.title
      subHeading=subHead
      details=lens.details
      highlight=highlight />

  render: ->
    classes = @getClasses()

    if not @props.can_upgrade_lenses
      COPY.lensTypes = _.omitBy COPY.lensTypes, (lens) ->
        if lens['type'] is 'high_index_167'
          true

    <div className=classes.block>
      <div className=classes.form>
        <h1 className=classes.header children=COPY.header />
        <p className=classes.intro children=COPY.intro />
        {_.map COPY.lensTypes, @renderLensChoice}
      </div>

      <CheckoutSummary
        totals=@props.totals
        itemCount={_.size(@props.items)}
        ctaCopy='' />
    </div>

