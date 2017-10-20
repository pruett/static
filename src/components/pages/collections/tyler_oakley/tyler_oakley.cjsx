React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'
TylerOakley = require 'components/organisms/collections/tyler_oakley/tyler_oakley'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/landing-page/tyler-oakley'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/tyler-oakley'
      handler: 'TylerOakley'
      title: 'Warby Parker x Tyler Oakley'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page -push-footer' {...@props}>
      {
        unless _.isEmpty content
          <TylerOakley {...content} />
      }
    </LayoutDefault>
