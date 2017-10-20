[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './radio_group.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gift-card-radio-group'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    name: ''
    options: []

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-grid__row
    "
    input: "
      #{@BLOCK_CLASS}__input
      u-hide--visual
    "
    button: "
      u-grid__col
      u-w12c u-w7c--600 u-w3c--900
    "
    label: "
      #{@BLOCK_CLASS}__label
      u-dib u-vam
      u-cursor--pointer
      u-w100p
      u-mb12
      u-color-bg--white
      u-bc--light-gray u-bw1 u-bss
      u-tal u-tac--900
      u-color--dark-gray-alt-2
      u-pr--900 u-h0--900
      u-pb1x1--900
    "
    copy: '
      u-db
      u-p18 u-p0--900
      u-pa--900 u-t0--900 u-l0--900
      u-center--900
      u-w100p u-w10c--900
    '
    heading: "
      u-dib u-db--900
      u-vam
      u-w3c u-w100p--900
      u-mb12--900
      u-pr10
    "
    subhead: "
      #{@BLOCK_CLASS}__subhead
      u-body-small
      u-dib u-db--900
      u-vam
      u-w9c u-w100p--900
    "

  classesWillUpdate: ->
    showLargeHeading = @maxChars('heading') < 5

    heading:
      'u-heading-sm': not showLargeHeading
      'u-heading-md -large': showLargeHeading

  maxChars: (type) ->
    max = _.maxBy @props.options, (option) -> _.get(option, type).length
    max[type].length

  handleClick: (evt) ->
    @props.manageClick(evt) if _.isFunction @props.manageClick

  renderButton: (option, i) ->
    <div className=@classes.button key=i>
      <input
        id="#{@props.name}-#{i}"
        value=option.value
        type='radio'
        name=@props.name
        className=@classes.input
        onChange=@handleClick />
      <label
        htmlFor="#{@props.name}-#{i}"
        className=@classes.label>
        <span className=@classes.copy>
          <span className=@classes.heading children=option.heading />
          <span className=@classes.subhead children=option.subhead />
        </span>
      </label>
    </div>

  render: ->
    @classes = @getClasses()

    <div className=@classes.block
      children={_.map @props.options, @renderButton} />
