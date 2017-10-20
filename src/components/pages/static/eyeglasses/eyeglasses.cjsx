[
  _
  React

  LayoutDefault

  EyeSun

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/eye_sun/eye_sun'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  CONTENT_PATH: '/eyeglasses-responsive'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/eyeglasses'
      handler: 'Eyeglasses'
      title: 'Eyeglasses'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'routing'
  ]

  render: ->
    content = @getContentVariation(@CONTENT_PATH)

    <LayoutDefault {...@props} cssModifier='-full-width'>
      <EyeSun {...content} />
    </LayoutDefault>
