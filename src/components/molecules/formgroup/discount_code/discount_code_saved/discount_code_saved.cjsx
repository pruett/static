[
  _
  React

  IconX

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './discount_code_saved.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-discount-code-saved'

  mixins: [
    Mixins.classes
    Mixins.conversion
    React.addons.LinkedStateMixin
  ]

  propTypes:
    code: React.PropTypes.object
    response: React.PropTypes.object

  getInitialState: ->
    code: {}
    response: {}

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-pt12 u-pr6 u-pb12 u-pl6
      u-pr
    "
    codeComplete: '
      u-fs16 u-ffss
      u-color--dark-gray-alt-3
    '
    message: '
      u-fs14 u-ffss
      u-color--dark-gray-alt-2
    '
    removeButton: "
      #{@BLOCK_CLASS}__button
      u-p8
      u-pa
      u-center-y
      u-color-bg--light-gray
    "
    x: "
      #{@BLOCK_CLASS}__x
      u-icon u-fill--white
    "

  handleClickRemove: (evt) ->
    if _.isFunction @props.onClickRemove
      code = @getDiscountFields(@props.code).code
      @props.onClickRemove code

  getDiscountFields: (code) ->
    if code.payment_type is 'gift_card'
      code: code.gift_card_code
      message: "$#{@convert 'cents', 'dollars', code.amount} off"

    else if code.code
      code: code.code
      message: switch code.discount_type
        when 'absolute'
          "$#{@convert 'cents', 'dollars', code.discount_value} off"
        when 'percent'
          "#{code.discount_value / 100}% off"

    else
      code: 'Error'
      message: 'No'

  render: ->
    classes = @getClasses()
    discount = @getDiscountFields @props.code

    <div className=classes.block>
      <div
        children=discount.code
        className=classes.codeComplete />

      <div
        children="#{discount.message} discount applied"
        className=classes.message />

      <button
        type='button'
        className=classes.removeButton
        onClick=@handleClickRemove>
        <IconX cssUtility=classes.x />
      </button>
    </div>
