[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './sizing_details.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-sizing-details'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.scrolling
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    filters: React.PropTypes.object
    isOpen: React.PropTypes.bool
    product: React.PropTypes.object

  getDefaultProps: ->
    cssModifier: ''
    product: {}
    staffGallery: false

  getInitialState: ->
    buttonSeen: false

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-clearfix
      u-pt24 u-pb24"
    groups: 'u-cl
      u-df u-jc--sb u-ai--fs u-db--900
      u-clearfix--900'
    group: 'u-fl--900 u-oh
      u-flex--1
      u-mw50p--900
      u-mr30--900 u-mr48--1200'
    label: 'u-ffss u-fws u-fs12 u-ttu u-ls1_5'
    value: "#{@BLOCK_CLASS}__value
      u-dib--600 u-db--900
      u-mt6
      u-ffss u-fwn u-fs16 u-fs18--1200
      u-color--dark-gray-alt-3"
    buttonWrap: 'u-cl
      u-pt36 u-pb3'
    descriptionToggle: 'u-button -button-white
      u-pea
      u-fs16 u-ffss u-fws'
    thumbnail: "#{@BLOCK_CLASS}__thumbnail
      u-vam u-ml12 u-mr6"

  classesWillUpdate: ->
    descriptionToggle:
      "u-tal #{@BLOCK_CLASS}__staffButton": @props.staffGallery
      '-button-medium': not @props.staffGallery
    buttonCopy:
      'u-ml18 u-mr6': @props.staffGallery


  componentDidMount: ->
    @addScrollListener @trackIfButtonSeen
    @trackIfButtonSeen()

  trackIfButtonSeen: ->
    if @refIsInViewport(@refs.button) and not @state.buttonSeen
      # We'll also bucket WARB-2857 here when it's ready
      @trackInteraction 'pdp-view-moreFitDetails'
      @setState buttonSeen: true

  renderMeasurementsValue: ->
    measurements = _.get @props, 'product.measurements'
    if measurements
      _.map ['lens_width', 'bridge_width', 'temple_length'],
        (dimension) -> measurements[dimension]
      .join '-'
    else
      '–'

  handleDescriptionToggle: (evt) ->
    evt.preventDefault()
    @trackInteraction "#{@props.product.analytics_category}-click-sizingDetailsToggle-opening",
      evt
    # Just used to trigger Inspectlet
    @trackInteraction('pdp-click-staffGalleryButton') if @props.staffGallery
    @commandDispatcher 'frameProduct', 'toggleSizingDetails'

  render: ->
    classes = @getClasses()
    buttonCopy = if @props.staffGallery then "More photos and details" else "More fit details"
    <div className=classes.block>
      <div className=classes.groups>
        <div className=classes.group>
          <div children='Frame fit' className=classes.label />
          <div children={_.get @props, 'product.width_group', '–'} className=classes.value />
          {if @props.product.is_low_bridge_fit
            <div children='Low Bridge' className=classes.value />
          }
        </div>
        <div className=classes.group>
          <div children='Measurements' className=classes.label />
          <div children=@renderMeasurementsValue(@props.filters) className=classes.value />
        </div>
      </div>
      <div className=classes.buttonWrap>
        <button ref='button'
          className=classes.descriptionToggle
          onClick=@handleDescriptionToggle>

          {if @props.staffGallery
            <img className=classes.thumbnail src={@props.fitThumbnail} alt="Staff member wearing glasses" /> }
          <span className=classes.buttonCopy children=buttonCopy />
        </button>
      </div>
    </div>
