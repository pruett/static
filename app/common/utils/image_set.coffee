_ = require 'lodash'

DIMENSIONS =
  # Since dimensions must be registered with our image server, we
  # hard-code them here. Optionally, they can be passed down by the
  # API.
  #
  # The dimensions below should be updated when they are
  # updated in the wp.io.image module.
  #
  # `standard` = 2:1 aspect ratio
  standard_250:  [ 250, 125]
  standard_500:  [ 500, 250]
  standard_750:  [ 750, 375]
  standard_1000: [1000, 500]
  standard_1250: [1250, 625]
  standard_1500: [1500, 750]
  standard_1750: [1750, 875]
  standard_2000: [2000, 1000]
  original: null

imageURL = (mode, orientation, dimension) ->
  expanded_dimension = if dimension? then "/#{dimension[0]}x#{dimension[1]}" else ''
  "#{mode}/#{orientation}#{expanded_dimension}.jpg?quality=80"

module.exports =
  unpack: (imageSet) ->
    dimensions   = imageSet.dimensions or DIMENSIONS
    modes        = imageSet.modes
    orientations = imageSet.orientations
    unpacked     = {}

    # If `imageSet` isn't unpackable, we return it unchanged.
    if modes and orientations
      for mode in _.keys(modes)
        unpacked[mode] or= {}
        for orientation in _.keys(orientations)
          unpacked[mode][orientation] or= {}
          for dimension in _.keys(dimensions)
            unpacked[mode][orientation][dimension] = imageURL(
              modes[mode]
              orientations[orientation]
              dimensions[dimension]
            )
      unpacked
    else
      imageSet
