[
  React

  RightArrowIcon
  CTA

  Mixins
] = [
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'

  require './flow_choice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-flow-choice'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    icon: React.PropTypes.node
    heading: React.PropTypes.string
    subHeading: React.PropTypes.string
    isCallout: React.PropTypes.bool
    hasRightarrow: React.PropTypes.bool
    tagName: React.PropTypes.oneOf ['a', 'button', 'label']

  getDefaultProps: ->
    icon: ''
    heading: ''
    subHeading: ''
    isCallout: false
    hasRightArrow: true
    tagName: 'a'

  getStaticClasses: ->
    button: "
      #{@BLOCK_CLASS}
      u-button -button-white -button-full -button-left -v2
      u-cursor--pointer
      "
    icon: "
      #{@BLOCK_CLASS}__icon
      "
    headings: "
      #{@BLOCK_CLASS}__headings
      u-dib u-valign--middle
      "
    heading: "
      #{@BLOCK_CLASS}__heading
      u-ffss u-fs16 u-fws
      u-db
      "
    subHeading: "
      #{@BLOCK_CLASS}__sub-heading
      u-ffss u-fs14
      u-db
      u-wsn
      u-color--dark-gray-alt-3
      "
    icon: "
      #{@BLOCK_CLASS}__icon
      "
    arrow: "
      #{@BLOCK_CLASS}__arrow
      u-fill--light-gray
      "

  classesWillUpdate: ->
    headings:
      '-has-icon': @props.icon

  render: ->
    classes = @getClasses()

    <@props.tagName {...@props} className=classes.button>

      {if @props.icon
        <span className=classes.icon children=@props.icon />}

      <span className=classes.headings>
        <span className=classes.heading children=@props.heading />

        {if @props.subHeading
          <span className=classes.subHeading children=@props.subHeading />}
      </span>

      {if @props.hasRightArrow
        <RightArrowIcon cssModifier=classes.arrow />}

      {@props.children}
    </@props.tagName>
