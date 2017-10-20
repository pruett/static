[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'
]

module.exports = React.createClass
  propTypes:
    imageSet: React.PropTypes.object
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  componentDidMount: ->
    @runPicturefill()

  componentDidUpdate: ->
    @runPicturefill()

  runPicturefill: ->
    window?.picturefill? elements: [React.findDOMNode(@refs.img)]

  render: ->
    props = _.assign {}, _.omit(@props, 'cssModifier')

    if @props.imageSet
      srcSet = []

      for key, value of @props.imageSet
        size = parseInt _.last(key.split('_')), 10
        if not isNaN(size)
          srcEntry = "#{value} #{size}w"
          srcSet.push srcEntry

      _.assign props, srcSet: srcSet.join(',')

    <img
      {...props}
      className=@props.cssModifier
      ref='img' />
