[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'
]

module.exports = React.createClass
  propTypes:
    cssModifier: React.PropTypes.string
    cssModifierPicture: React.PropTypes.string
    cssModifierImg: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  componentDidMount: ->
    @runPicturefill()

  componentDidUpdate: ->
    @runPicturefill()

  runPicturefill: ->
    window?.picturefill? elements: [
      React.findDOMNode(@refs.picture).querySelector('img')
    ]

  render: ->
    props = _.assign {}, @props

    if props.cssModifierImg and not props.cssModifier
      props.cssModifier = props.cssModifierImg

    <picture
      {...props}
      className={@props.cssModifier or @props.cssModifierPicture}
      ref='picture' />
