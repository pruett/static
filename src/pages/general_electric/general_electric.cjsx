[
  _
  React

  LayoutDefault

  GeneralElectric

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/general_electric/general_electric'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  CONTENT_PATH: '/ge'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/ge'
      handler: 'GeneralElectric'
      title: 'General Electric'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation(@CONTENT_PATH)

    <LayoutDefault {...@props} cssModifier='-full-width'>
      <GeneralElectric {...content} />
    </LayoutDefault>
