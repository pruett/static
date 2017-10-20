_ = require 'lodash'

module.exports =

  TEMPLATES: [
    'stacked'
    'parallel'
    'overlap'
  ]

  SIZES: [
    name: 'desktop-hd'
    widthMin: 1200
    widthMax: 1440
  ,
    name: 'desktop-sd'
    widthMin: 900
    widthMax: 1200
  ,
    name: 'tablet'
    widthMin: 600
    widthMax: 900
  ,
    name: 'mobile'
    widthMin: 0
    widthMax: 600
  ]

  COLOR_LOOKUP:
    black: 'u-color--black'
    white: 'u-color--white'
    light: 'u-color--light-gray'
    standard: 'u-color--dark-gray-alt-3'

  getTypeIndex: (type, props) ->
    elements = _.filter @props.elements, type: type
    elements.indexOf(props) + 1
