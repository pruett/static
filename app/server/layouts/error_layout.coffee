[
  BlankLayout
] = [
  require './blank_layout'
]

class ErrorLayout extends BlankLayout
  name: -> 'error'

  afterBodyOpen: -> null

module.exports = ErrorLayout
