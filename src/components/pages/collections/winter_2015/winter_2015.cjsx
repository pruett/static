[
  _
  React

  LayoutDefault

  Winter2015Collection

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/collections/winter_2015/collection/collection'
  require 'components/mixins/mixins'

  require './winter_2015.scss'
]

module.exports = React.createClass
  CONTENT_PATH: '/winter-2015'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/winter-2015/{version?}'
      handler: 'Winter2015'
      title: 'Winter 2015'

  getVersion: ->
    params = @getRouteParams()
    version = params.version ? 'fans'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  getDefaultProps: ->
    cssModifier: '-full-width'

  render: ->
    content = @getContentVariation @CONTENT_PATH
    version = @getVersion()

    <LayoutDefault {...@props}>
      {if content
        <Winter2015Collection version=version content=content appState=@props.appState />}
    </LayoutDefault>
