[
  _
  React

  LayoutDefault

  Fall2015Collection

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/collections/fall_2015/collection/collection'

  require 'components/mixins/mixins'

  require './fall_2015.scss'
]

module.exports = React.createClass
  CONTENT_PATH: '/fall-2015'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/fall-2015/{version?}'
      handler: 'Fall2015'
      title: 'Fall 2015'

  fetchVariations: -> [
    @getContentPath()
  ]

  getDefaultProps: ->
    cssModifier: '-full-width'

  getContentPath: ->
    params = @getRouteParams()
    pathSuffix = if params['version'] then "/#{params['version']}" else ''

    return @CONTENT_PATH + pathSuffix

  getVersion: ->
    params = @getRouteParams()
    version = params.version ? 'fans'

  render: ->
    path = @getContentPath()
    content = @getContentVariation path
    version = @getVersion()

    <LayoutDefault {...@props}>
      {if content
        <Fall2015Collection version=version content=content appState=@props.appState />}
    </LayoutDefault>
