_ = require 'lodash'

makeStartCase = (str) ->
  str = if str then "#{str}" else ''
  str = str.replace /\b\w/g, (letter) -> letter.toUpperCase()
  str.replace /\b(A|An|And|By|For|From|Of|Or|With)\b/g, (word) -> word.toLowerCase()

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
