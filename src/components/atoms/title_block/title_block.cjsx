[
  React
] = [
  require 'react/addons'

  require './title_block.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-title-block'

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

    txtTitle: React.PropTypes.string
    children: React.PropTypes.node

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: ''

    txtTitle: ''
    children: ''

  render: ->
    <div className="#{@BLOCK_CLASS} #{@props.cssUtility} #{@props.cssModifier}">
      <h1 className="#{@BLOCK_CLASS}__title u-reset u-fs16 u-fws">
        {@props.txtTitle}
      </h1>
      <h2 className="#{@BLOCK_CLASS}__description u-reset u-fs16 u-fwn">
        {@props.children}
      </h2>
    </div>
