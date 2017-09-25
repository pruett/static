[
  _
  React

  LayoutDefault

  Help

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/help/help'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/responsive/help'

  statics:
    route: ->
      path: '/help'
      handler: 'Help'
      title: 'Help'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault {...@props} cssModifier="-full-width">
      {if content
        <Help {...@props} content=content />}
    </LayoutDefault>
