React = require 'react/addons'
ExternalSvg  = require 'components/atoms/images/external_svg/external_svg'

require './logo.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-warbyparker-logo'

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: ''
    cssModifier: ''

  render: ->
    <ExternalSvg altText='Warby Parker'
      cssModifier="#{@props.cssModifier} #{@props.cssUtility}"
      parentClass=@BLOCK_CLASS />
