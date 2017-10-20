[
  _
  React

  LayoutDefault

  Progressives

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/progressives/progressives'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/progressives'
      handler: 'Legacy'
      title: 'Progressives'

  render: ->
    <LayoutDefault {...@props} cssModifier='-full-width'>
      <Progressives />
    </LayoutDefault>
