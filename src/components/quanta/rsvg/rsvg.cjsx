_     = require 'lodash'
React = require 'react/addons'

require './rsvg.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-rsvg'

  propTypes:
    SVG: React.PropTypes.shape
      class: React.PropTypes.string
      width: React.PropTypes.number
      height: React.PropTypes.number
    cssSVG: React.PropTypes.string
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssVariation: React.PropTypes.string
    id: React.PropTypes.string

  getDefaultProps: ->
    SVG:
      class: ''
      height: 1
      width: 1

    title: ''
    cssUtility: ''
    cssModifier: ''
    cssVariation: ''

  componentDidMount: ->
    # Unfortunately focusable isn't among the whitelisted attributes.
    # See HTMLDOMPropertyConfig.js
    @refs.svg.getDOMNode().setAttribute('focusable', 'false')

  render: ->
    className = [
      @props.SVG.class
      @props.cssModifier
      @props.cssUtility
      @props.cssVariation
    ].join ' '

    # Responsively size inner container.
    <span className=className>
      <span className="#{@BLOCK_CLASS} #{@props.SVG.class}__rsvg">
        <svg
          ref='svg'
          className="c-rsvg__svg"
          viewBox="0 0 #{@props.SVG.width} #{@props.SVG.height}"
          aria-labelledby=@props.id>
          <title id=@props.id children=@props.title className="u-hide--visual" />
          {@props.children}
        </svg>
      </span>
    </span>
