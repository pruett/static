Backbone = require '../backbone'

class ImageUploadModel extends Backbone.BaseModel

  url: -> @apiBaseUrl('image/upload')

  permittedAttributes: -> [
    'blob_id'
    'filename'
    'img_url'
  ]

module.exports = ImageUploadModel
