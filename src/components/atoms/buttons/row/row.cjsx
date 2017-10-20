[
  React

  RightArrow

  Mixins
] = [
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require './row.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-row-button'

  propTypes:
    children: React.PropTypes.node
    route: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    route: ''
    children: 'Row'
    cssModifier: ''

  render: ->
    <a href="#{@props.route}"
      className="#{@BLOCK_CLASS} u-reset u-ffss">
      <span className="#{@BLOCK_CLASS}__content">{@props.children}</span>
      <RightArrow cssModifier={"#{@BLOCK_CLASS}__arrow"} />
    </a>
