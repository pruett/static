[
  _
  React
  Radio

  CardContentsDefault
  CardContentsOrder
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'backbone.radio'

  require 'components/atoms/card_contents/default/default'
  require 'components/atoms/card_contents/order/order'
  require 'components/mixins/mixins'

  require './card.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-card'

  propTypes:
    heading: React.PropTypes.string
    contents: React.PropTypes.func
    trigger: React.PropTypes.string
    icon: React.PropTypes.func
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    route: React.PropTypes.string

  getDefaultProps: ->
    heading: 'Heading'
    contents: null

    icon: null
    cssUtility: ''
    cssModifier: ''
    route: ''

  render: ->
    Component = if @props.id then CardContentsOrder else CardContentsDefault

    <a href=@props.route
      className="#{@BLOCK_CLASS} #{@props.cssModifier} #{@props.cssUtility}">
      <Component {...@props}/>
    </a>
