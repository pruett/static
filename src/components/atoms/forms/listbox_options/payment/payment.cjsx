[
  _
  React

  CreditCardIcon
  DownArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/icons/credit_card/credit_card'
  require 'components/quanta/icons/down_arrow/down_arrow'

  require 'components/mixins/mixins'

  require '../listbox_option.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-listbox-option'

  VARIATION_CLASS: 'c-listbox-option--payment'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    optionData: React.PropTypes.shape(
      cc_type: React.PropTypes.string
      cc_type_id: React.PropTypes.number
      cc_expires_month: React.PropTypes.number
      cc_expires_year: React.PropTypes.number
      cc_last_four: React.PropTypes.string
    )
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    showDot: false
    showDownArrow: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@VARIATION_CLASS}
      #{@props.cssModifier}
    "
    creditCardIcon:
      "#{@VARIATION_CLASS}__credit-card-icon"
    creditCardDetail: "
      #{@VARIATION_CLASS}__credit-card-detail
      u-ffss u-fs16 u-m0 u-color--dark-gray-alt-3
      inspectlet-sensitive
    "
    downArrow: "
      #{@BLOCK_CLASS}__down-arrow
      u-fill--light-gray
    "
    dot: "
      #{@BLOCK_CLASS}__dot
      u-dib
    "

  getExpDate: ->
    month = _.get(@props, 'optionData.cc_expires_month', '').toString()
    year = _.get(@props, 'optionData.cc_expires_year', '').toString()

    if month.length is 1
      month = "0#{month}"
    year = year.substr(2, 2)

    [month, year].join '/'

  render: ->
    classes = @getClasses()

    <li {...@props}
      cssModifier={undefined}
      className=classes.block>
      {[
        <CreditCardIcon
          key='icon'
          cssModifier=classes.creditCardIcon
          cardType=@props.optionData.cc_type />

        if @props.showDot
          <div key='dot' className=classes.dot />

        <p
          key='detail'
          className=classes.creditCardDetail>
          {"Ending in #{@props.optionData.cc_last_four}"}
          <br />
          <span children="Expires #{@getExpDate()}" />
        </p>
      ]}

      {if @props.showDownArrow
        <DownArrow cssModifier=classes.downArrow />}
    </li>
