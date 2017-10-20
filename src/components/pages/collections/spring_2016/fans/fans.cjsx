[
  _
  React

  LayoutDefault
  SpringCollection


  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/collections/spring_2016/collection/collection'


  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/spring-2016'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/spring-2016'
      handler: 'Spring2016'
      title: 'Spring 2016'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  getDefaultProps: ->
    cssModifier: '-full-width'

  render: ->
    content = @getContentVariation @CONTENT_PATH
    version = 'fans'

    <LayoutDefault {...@props}>
      {if content
        <SpringCollection
          version=version
          appState=@props.appState
          content=content />}
    </LayoutDefault>
