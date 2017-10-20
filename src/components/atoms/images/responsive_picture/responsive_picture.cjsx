[
  _
  React

  Picture
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

]

module.exports = React.createClass
  getDefaultProps: ->
    cssModifier: ''
    altText: ''
    sourceImages: []

  componentDidMount: ->
    @runPicturefill()

  componentDidUpdate: ->
    @runPicturefill()

  runPicturefill: ->
    window?.picturefill? elements: [React.findDOMNode(@refs.img)]

  render: ->
    pictureSources = _.map @props.sourceImages, (source, i) =>
      sources = [source.image]
      for size in ['2x', '3x']
        img = _.get source, "image_#{size}"
        sources.push "#{img} #{size}" if img
      srcset = sources.join ', '

      if _.get source, 'min_width'
        <source
          key=i
          media="(min-width: #{source.min_width})"
          srcSet=srcset />
      else
        <img
          key='image'
          ref='img'
          className=@props.cssModifier
          alt=@props.altText
          src=source.image
          srcSet=srcset />

    <Picture children=pictureSources />
