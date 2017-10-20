[
  _
  React

  RightArrowIcon

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require './lens_choice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-lens-choice'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    onClick: React.PropTypes.func
    title: React.PropTypes.string
    details: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    highlight: false

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-button -button-block -button-left -button-white
      u-db u-mb12
    "
    title:
      'u-mt0 u-mb12 u-fs16 u-fws'
    subHeading: '
      u-mt0 u-mb12 u-fs14
      u-color--dark-gray-alt-3 u-lh20
    '
    details: '
      u-mt0 u-mb0
      u-fs14 u-lh20 u-color--dark-gray-alt-2
    '
    arrow: "
      #{@BLOCK_CLASS}__arrow
      u-fill--light-gray
    "

  classesWillUpdate: ->
    block:
      '-highlight': @props.highlight
    subHeading:
      'u-list-inside u-m0 u-p0': _.isArray @props.subHeading

  render: ->
    classes = @getClasses()

    <button {...@props} type='button' className=classes.block>
      <h1 className=classes.title children=@props.title />

      {if _.isString @props.subHeading
        <p className=classes.subHeading children=@props.subHeading />
      else if _.isArray @props.subHeading
        <ul className=classes.subHeading
          children={_.map @props.subHeading, (item, i) -> <li key=i children=item />} />}

      <p className=classes.details children=@props.details />

      <RightArrowIcon cssModifier=classes.arrow />
    </button>
