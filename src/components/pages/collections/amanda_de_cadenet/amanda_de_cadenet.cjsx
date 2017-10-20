React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'

AmandaDeCadenet = require 'components/organisms/collections/amanda_de_cadenet/amanda_de_cadenet'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/amanda-de-cadenet'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/amanda-de-cadenet'
      handler: 'AmandaDeCadenet'
      title: 'Amanda de Cadenet x Warby Parker'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page -push-footer' {...@props}>
      {
        unless _.isEmpty content
          <AmandaDeCadenet {...content} />
      }
    </LayoutDefault>
