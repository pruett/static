[
  Backbone
  AddressModel
] = [
  require '../backbone'
  require '../models/address_model'
]

class AddressCollection extends Backbone.BaseCollection
  model: AddressModel

  comparator: (a, b) ->
    # Most recently updated first.
    now = new Date().getTime()

    [aUpdated, bUpdated] = [now, now]

    try
      aUpdated = new Date(a.get 'updated').getTime()

    try
      bUpdated = new Date(b.get 'updated').getTime()

    bUpdated - aUpdated


module.exports = AddressCollection
