Backbone = require '../backbone'

class SessionModel extends Backbone.BaseModel
  url: -> @apiBaseUrl('session')

  defaults: ->
    customer: null
    cart:
      hto_limit_reached: false
      hto_quantity: 0
      hto_quantity_remaining: 5
      items: []
      quantity: 0


module.exports = SessionModel
