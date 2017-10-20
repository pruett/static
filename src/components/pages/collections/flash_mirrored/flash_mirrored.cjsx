React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'
FlashMirrored = require 'components/organisms/collections/flash_mirrored/flash_mirrored'
Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/flash-mirrored'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/flash-mirrored-sunglasses'
      handler: 'FlashMirrored'
      title: 'Flash Mirrored'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        unless _.isEmpty content
          <FlashMirrored {...content} />
      }
    </LayoutDefault>
