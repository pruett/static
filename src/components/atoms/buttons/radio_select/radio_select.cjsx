[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

require './radio_select.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-radio-select'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    handleChange: React.PropTypes.func.isRequired
    selected: React.PropTypes.bool.isRequired
    key: React.PropTypes.string
    title: React.PropTypes.string
    meta: React.PropTypes.string
    description: React.PropTypes.string

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-db u-pr u-cursor--pointer u-br1
      u-color-bg--light-gray-alt-2
      u-mt10
      u-fs16 u-ffss
    "
    input: "
      #{@BLOCK_CLASS}__input
      u-pa
    "
    indicator: "
      #{@BLOCK_CLASS}__indicator
      u-pa u-db u-color-bg--light-gray
    "
    headingContainer: "
      #{@BLOCK_CLASS}__heading-container
      u-clearfix
    "
    name: 'u-m0 u-color--dark-gray u-fws'

    meta: 'u-fr u-color--dark-gray-alt-2 u-fs14'

    desc: "
      #{@BLOCK_CLASS}__desc
      u-fs14 u-fwn u-mb0
      u-color--dark-gray-alt-3
    "

  classesWillUpdate: ->
    block:
      'u-color-bg--white': @props.selected

    indicator:
      '-selected': @props.selected

  render: ->
    classes = @getClasses()

    <label className=classes.block key=@props.key>
      <input
        className=classes.input
        type='radio'
        onChange=@props.handleChange
      />
      <span className=classes.indicator />
      <div className=classes.headingContainer>
        <span className=classes.name>{@props.title}</span>
        <span className=classes.meta>{@props.meta}</span>
      </div>
      <p className=classes.desc>{@props.description}</p>
    </label>
