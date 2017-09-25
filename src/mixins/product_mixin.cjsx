_ = require 'lodash'
{makeStartCase} = require 'hedeia/common/utils/string_formatting'

module.exports =

  getColorDisplayName: (item, variantType) ->
    color = makeStartCase _.get(item, 'color', '')
    if color
      lensColor = if variantType
        makeStartCase _.get(item, "variants.#{variantType}.lens_color", '')
      else
        makeStartCase _.get(item, 'lens_color', '')
      if lensColor and "#{_.get item, 'assembly_type'}".toLowerCase() is 'sunglasses'
        color = "#{color} with #{lensColor} lenses"
    return color
