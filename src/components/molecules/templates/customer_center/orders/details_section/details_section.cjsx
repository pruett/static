[
  React
  Mixins
] = [
  require 'react/addons'
  require 'components/mixins/mixins'
]

require './details_section.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-order-details-section'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    isHto: React.PropTypes.bool
    sectionType: React.PropTypes.oneOf ['shipping', 'payment']

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: ''
    isHto: false
    sectionType: 'shipping'

  getStaticClasses: ->
    block: @BLOCK_CLASS
    section: "#{@BLOCK_CLASS} #{@props.cssUtility} #{@props.cssModifier} grid__cell"
    heading: "#{@BLOCK_CLASS}__heading u-reset  u-fs12 u-ls2_5 u-ttu u-mb24 u-fwn"

  classesWillUpdate: ->
    section:
      'unit-1-2--tablet': not @props.isHto

  render: ->
    classes = @getClasses()

    headingText = if @props.isPickup
        'Delivery details'
      else if @props.isHto or @props.sectionType is 'shipping'
        'Shipping details'
      else if @props.sectionType is 'payment'
        'Payment details'

    <section className=classes.section>
      <h2 className=classes.heading
        children=headingText />

      {@props.children}
    </section>
