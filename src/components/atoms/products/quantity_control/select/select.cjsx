React = require 'react/addons'

DownArrow = require 'components/quanta/icons/down_arrow/down_arrow'

Mixins = require 'components/mixins/mixins'

require './select.scss'


module.exports = React.createClass
  BLOCK_CLASS: 'c-product-quantity-select'

  mixins: [Mixins.classes]

  propTypes:
    applePay: React.PropTypes.bool
    changeQuantity: React.PropTypes.func
    cssModifier: React.PropTypes.string
    selectedQuantity: React.PropTypes.number

  getDefaultProps: ->
    changeQuantity: ->
    cssModifier: ''
    selectedQuantity: 1

  getStaticClasses: ->
    block:
      @props.cssModifier
    select:
      "#{@BLOCK_CLASS}__select
      u-pa u-l0 u-t0
      u-h100p u-w100p
      u-fs16"
    output:
      "#{@BLOCK_CLASS}__output
      u-fs16 u-fws u-ffss
      u-color-bg--light-gray-alt-3
      u-bc--light-gray
      u-bw1 u-bss
      u-tac
      u-h60
      u-w100p
      u-df u-jc--c u-ai--c"
    arrow:
      "#{@BLOCK_CLASS}__arrow
      u-ml6"

  classesWillUpdate: ->
    block:
      'u-mb12 u-mb0--600': @props.applePay
    output:
      '-rounded': @props.applePay

  handleChange: (evt) ->
    @props.changeQuantity parseInt evt.target.value

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <select className=classes.select
        onChange=@handleChange
        children={
          [1..10].map (i) ->
            <option
              children=i
              key=i
              value=i />
        } />

      <output className=classes.output>
        {@props.selectedQuantity}
        <DownArrow cssModifier=classes.arrow />
      </output>
    </div>
