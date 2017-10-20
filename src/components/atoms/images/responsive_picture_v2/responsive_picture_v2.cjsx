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
# This version slims down the source_image collection to just an image and size.
# You pass a sizes lookup table that auto generates image sizes at breakpoints.
# You can use whatever keys you want to refer to the different images.
# T-shirt sizes work well for multiple different images.
#
# Size example in home_index.cjsx
  propTypes:
    cssModifier: React.PropTypes.string
    altText: React.PropTypes.string
    sourceImages: React.PropTypes.array
    quality: React.PropTypes.number
    sizes: React.PropTypes.object
    renderDefault: React.PropTypes.bool

  getDefaultProps: ->
    cssModifier: ''
    altText: ''
    sourceImages: []
    quality: 70
    sizes: {}
    renderDefault: true
    requestOriginalImages: false

  componentDidMount: ->
    @runPicturefill()

  componentDidUpdate: ->
    @runPicturefill()

  runPicturefill: ->
    picture = React.findDOMNode @refs.picture
    return unless picture

    img = picture.querySelector 'img'
    if img
      window?.picturefill? elements: [img]

  renderSourceMarkup: (acc, source, index, sources) ->
    # If we're rendering a default source in <img />, don't give the last source
    # its own <source /> element.
    return acc if sources.length - 1 is index and @props.renderDefault

    acc += "<source media='(min-width: #{source.breakpoint}px)'
      srcset='#{source.srcSet}' />"

  renderImgMarkup: (sources) ->
    defaultSource =
      if sources.length > 0 and @props.renderDefault
        "srcset='#{sources.pop().srcSet}'"
      else
        ''

    "<img class='#{@props.cssModifier}'
      alt='#{@props.altText}'
      #{defaultSource} />"

  renderChildrenMarkup: (sources) ->
    "<!--[if IE 9]><video style='display: none'><![endif]-->
    #{_.reduce(sources, @renderSourceMarkup, '')}
    <!--[if IE 9]></video><![endif]-->
    #{@renderImgMarkup sources}"

  reduceSource: (sources, source) ->
    size = _.get @props, "sizes.#{source.size}"

    if _.isArray size

      quality = source.quality or @props.quality
      prepend = "#{source.image}?quality=#{quality}&width="

      # Create source information based on breakpoints given.
      _.map size, (width) ->
        srcSet = "#{prepend}#{width.image},
          #{prepend}#{width.image * 1.5} 1.5x,
          #{prepend}#{width.image * 2} 2x"

        sources.push
          image: source.image
          imageWidth: width.image
          breakpoint: width.break
          srcSet: srcSet

    sources

  mapWidths: (width, key) ->
    images = _.sortBy(_.filter(@props.sourceImages, 'size': key), 'resolution')
    imageList = _.map images, (img, i) ->
      if i is 0 then img.image else "#{img.image} #{img.resolution}"

    image: _.get(_.first(images), 'image')
    imageWidth: width.image
    breakpoint: width.break
    srcSet: imageList.join ', '

  render: ->
    return false if _.isEmpty @props.sourceImages or _.isEmpty @props.sizes

    # Merge together size attributes and source needs.
    if @props.requestOriginalImages
      sources = _.map @props.sizes, @mapWidths
    else
      sources = _.reduce @props.sourceImages, @reduceSource, []

    # Make sure in descending order.
    sortSources = _.orderBy sources, ['breakpoint', 'imageWidth'], 'desc'

    <Picture ref='picture'
      dangerouslySetInnerHTML={__html: @renderChildrenMarkup sortSources} />
