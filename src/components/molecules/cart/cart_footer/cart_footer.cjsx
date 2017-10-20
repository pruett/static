[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'

  require './cart_footer.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-cart-footer'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    bottomContent: React.PropTypes.oneOfType [
      React.PropTypes.array
      React.PropTypes.object
    ]
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    heading: React.PropTypes.string
    showSubtotal: React.PropTypes.bool
    subheading: React.PropTypes.string
    subtotal: React.PropTypes.string
    topContent: React.PropTypes.oneOfType [
      React.PropTypes.array
      React.PropTypes.object
    ]

  getDefaultProps: ->
    bottomContent: null
    cssModifier: ''
    cssUtility: ''
    heading: ''
    showSubtotal: false
    subheading: ''
    subtotal: ''
    topContent: null

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssUtility
      @props.cssModifier
    ]
    heading: [
      "#{@BLOCK_CLASS}__heading"
      'u-reset u-fs20'
      'u-ffs'
      'u-fws'
    ]
    subheading: [
      "#{@BLOCK_CLASS}__subheading"
      'u-reset u-fs16 u-mb24'
      'u-ffs'
    ]
    topContent: "#{@BLOCK_CLASS}__top-content"
    bottomContent: "#{@BLOCK_CLASS}__bottom-content"
    subtotal: "#{@BLOCK_CLASS}__subtotal"
    subtotalLabel: [
      "#{@BLOCK_CLASS}__subtotal-label"
      'u-reset u-fs16'
      'u-ffss'
      'u-fws'
    ]

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {if @props.showSubtotal
        <div className=classes.subtotal>
          <span children='Subtotal: ' className=classes.subtotalLabel />
          <span children=@props.subtotal />
        </div>}
      <div children=@props.topContent className=classes.topContent />
      {if @props.heading
        <div children=@props.heading className=classes.heading />}
      {if @props.subheading
        <div children=@props.subheading className=classes.subheading />}
      <div children=@props.bottomContent className=classes.bottomContent />
    </div>
