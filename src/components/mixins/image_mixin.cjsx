# This mixin contains helper methods for embedding responsive images. See
# https://github.com/WarbyParker/helios/wiki/Component-Lab:-Images for context,
# examples, etc.

_ = require 'lodash'
React = require 'react/addons'

module.exports =
  getEmptyImage: ->
    'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'

  getImageWidths: (start, end, count) ->
    # Gets a range of integers for images.
    # (200, 800, 7) => [200, 286, 372, 458, 543, 629, 715, 800]
    _.range(start, end + 1,  (end  - start) / count ).map (val) -> Math.floor(val)

  getImageBySize: (images, size = 'xs') ->
    # Helper function until moved off key system.
    # `images`: Collection of images to query.
    # `size`: Named key coming from CMS.
    _.get _.find(images, 'size': size), 'image', ''

  getQualityBySize: (images, size = 'xs') ->
    # Helper function until moved off key system.
    # `images`: Collection of images to query.
    # `size`: Named key coming from CMS.
    _.get _.find(images, 'size': size), 'quality', ''

  getSrcSet: (attrs) ->
    # `attrs.url`: Required string that points to base image URL.
    # `attrs.widths`: Required array of image widths to create.
    #   These can be an integer representing pixel width or an object with fields:
    # `attrs.widths.pixels`: Required number to set image width in srcset.
    # `attrs.widths.quality`: Optional number to set the image quality per-image.
    # `attrs.quality`: Optional number to set fallback image quality (defaults to 70).

    return '' unless (_.isString(attrs.url) and _.isArray(attrs.widths))

    quality = attrs.quality or 70

    attrs.widths.map((width) ->
      if _.isObject width
        "#{attrs.url}?quality=#{width.quality or quality}&width=#{width.pixels} #{width.pixels}w"
      else
        "#{attrs.url}?quality=#{quality}&width=#{width} #{width}w"
    ).join ','

  getImgSizes: (sizes = [breakpoint: 0, width: '100vw']) ->
    # Takes an array of objects with keys:
    #   `breakpoint`: Int specifying a max-width in pixels
    #   `width`: String with units, eg: '500px', '50vw', etc
    # and returns a sizes string to be used with the Img component

    _.map(_.orderBy(sizes, 'breakpoint', 'desc'), (size) ->
      if size.breakpoint is 0
        size.width
      else
        "(min-width: #{size.breakpoint}px) #{size.width}"
    ).join ','

  renderSource: (attrs, i) ->
    # `attrs.url` and `attrs.widths`: Required for `getSrcSet` call (see above).
    # `attrs.mediaQuery`: Required string describing condition(s) to use this source.
    # `attrs.media_query`: CMS number set to min-width, fallback to `mediaQuery`.
    # `attrs.sizes`: Optional string to define size attribute.
    return '' unless (_.isString(attrs.url) and
      _.isArray(attrs.widths) and
      (_.isString(attrs.mediaQuery)) or _.isString(attrs.media_query))

    props =
      key: i
      media: attrs.media_query or attrs.mediaQuery or '(min-width: 0px)'
      srcSet: if attrs.url is @getEmptyImage() then attrs.url else @getSrcSet attrs

    if _.isString(attrs.sizes)
      props.sizes = attrs.sizes

    <source {...props} />

  getPictureChildren: (attrs={}) ->
    # `attrs.sources`: Required array of sources, each passed to `renderSource`.
    # `attrs.img: Optional object to pass to `img` as props.

    return [] unless _.isArray attrs.sources

    img = attrs.img or {}
    imgProps = _.defaults img,
      alt: ''
      src: @getEmptyImage()

    [
      attrs.sources.map(@renderSource)
    ,
      <img {...imgProps} key='img' />
    ]
