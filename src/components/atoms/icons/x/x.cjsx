React = require 'react/addons'
ExternalSvg = require 'components/atoms/images/external_svg/external_svg'

require './x.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-x-icon'

  propTypes:
    altText: React.PropTypes.string
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    altText: 'Close'
    cssUtility: ''
    cssModifier: ''

  render: ->
    <ExternalSvg altText=@props.altText
      cssModifier="#{@props.cssModifier} #{@props.cssUtility}"
      parentClass=@BLOCK_CLASS />
