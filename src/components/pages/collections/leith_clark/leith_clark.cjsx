React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'
LeithClark = require 'components/organisms/collections/leith_clark/leith_clark'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/landing-page/leith-clark'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/leith-clark'
      handler: 'LeithClark'
      title: 'Leith Clark'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        unless _.isEmpty content
          <LeithClark {...content} />
      }
    </LayoutDefault>
