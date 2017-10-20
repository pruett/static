[
  React

  RightArrow

  Mixins
] = [
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require './step.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-step'

  propTypes:
    txtLabel: React.PropTypes.string
    children: React.PropTypes.node
    route: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    txtLabel: ''
    children: 'Next Step'
    route: ''

    cssUtility: 'u-reset u-fs16 u-ffss'
    cssModifier: ''

  render: ->
    <a href="#{@props.route}"
      className="#{@BLOCK_CLASS} #{@props.cssUtility}"
      {...@props}>

      {if @props.txtLabel
        <label
          className="#{@BLOCK_CLASS}__label u-reset u-fws"
          children={@props.txtLabel} />}

        <span className="#{@BLOCK_CLASS}__description">{@props.children}</span>
      <RightArrow cssModifier={"#{@BLOCK_CLASS}__arrow"} />
    </a>
