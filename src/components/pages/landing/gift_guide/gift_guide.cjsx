React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'
GiftGuide = require 'components/organisms/landing/gift_guide/gift_guide'


Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/gift-guide'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/holiday-gift-guide'
      handler: 'GiftGuide'
      title: 'Gift Guide'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        unless _.isEmpty content
          <GiftGuide {...content} />
      }
    </LayoutDefault>
