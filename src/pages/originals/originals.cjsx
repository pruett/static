[
  _
  React

  LayoutDefault

  Originals
  Breadcrumbs

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/originals/originals'
  require 'components/atoms/breadcrumbs/breadcrumbs'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/originals'
      title: 'Originals'
      handler: 'Legacy'

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'Originals'}
  ]

  render: ->
    <LayoutDefault {...@props} cssModifier='-full-page'>
      <Breadcrumbs links=@breadcrumbs />
      <Originals />
    </LayoutDefault>
