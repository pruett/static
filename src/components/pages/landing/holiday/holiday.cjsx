[
  _
  React

  LayoutDefault

  Holiday

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/collections/holiday/holiday'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/holiday'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/holiday'
      handler: 'Holiday'
      title: 'Holiday'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    <LayoutDefault {...@props}>
      <Holiday content=@getContentVariation(@CONTENT_PATH) />
    </LayoutDefault>
