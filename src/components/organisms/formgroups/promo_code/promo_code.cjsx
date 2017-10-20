[
  _
  React

  DiscountCodeInput
  DiscountCodeSaved
  Error
  FieldContainer
  IconAdd

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/formgroup/discount_code/discount_code_input/discount_code_input'
  require 'components/molecules/formgroup/discount_code/discount_code_saved/discount_code_saved'
  require 'components/molecules/formgroup/error/error'
  require 'components/organisms/formgroups/field_container/field_container'
  require 'components/quanta/icons/add/add'

  require 'components/mixins/mixins'

  require '../formgroup.scss'
  require './promo_code.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  BLOCK_CLASS: 'c-formgroup'

  VARIATION_CLASS: 'c-formgroup--promo'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  propTypes: ->
    txtError: React.PropTypes.string
    codes: React.PropTypes.array

  getDefaultProps: ->
    txtError: ''
    codes: []
    cssModifier: ''

  getInitialState: ->
    showInput: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssModifier}
    "
    codes: '
      u-bss u-bw1 u-bc--light-gray
      u-mt36 u-mb18
      u-pl18 u-pr18
    '
    toggle: "
      #{@VARIATION_CLASS}__toggle
      u-fs14 u-fws
      u-button-reset"

  classesWillUpdate: ->
    toggle:
      'u-color--blue': not @state.showInput
      'u-color--dark-gray': @state.showInput

  componentWillReceiveProps: (nextProps) ->
    return unless _.isEmpty nextProps.discountError

    if nextProps.codes.length isnt @props.codes.length or
    @codeWasReplaced nextProps.codes
      @setState showInput: false

  codeWasReplaced: (nextCodes) ->
    # A new code replaced an old one if two arrays of codes don't match.
    not _.reduce nextCodes, (acc, code, i) =>
      return false unless i of @props.codes

      oldCodeData = @props.codes[i]
      oldCode = oldCodeData.gift_card_code ? oldCodeData.code
      newCode = code.gift_card_code ? code.code

      # New code at i matches the previous one.
      acc and newCode is oldCode
    , true

  handleClickToggle: ->
    @setState showInput: not @state.showInput

  getHeaderCopy: ->
    "Redeem
    #{if @props.codes.length then 'another' else 'a'}
    #{if @getFeature('giftCards') then 'gift card or' else ''}
    promo code"

  renderSavedCode: (code, i) ->
    <DiscountCodeSaved
      onClickRemove=@props.manageRemove
      code=code
      key="code-#{i}" />

  render: ->
    classes = @getClasses()

    <div className=classes.block>

      {if @props.codes.length
        <div
          className=classes.codes
          children={_.map @props.codes, @renderSavedCode} />}

      <button type='button'
        className=classes.toggle
        onClick=@handleClickToggle
        children={@getHeaderCopy()} />

      <ReactCSSTransitionGroup
        transitionName='-transition-promo-code'
        transitionAppear>
        {if @state.showInput
          [
            <DiscountCodeInput
              key='input'
              manageApply=@props.manageApply
              txtError=@props.txtError />

            <Error txtError=@props.txtError.generic />
          ]
        }
      </ReactCSSTransitionGroup>

    </div>
