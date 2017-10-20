[
  _
  React

  LayoutDefault

  Design
  Breadcrumbs
  DoGoodNav

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/design/design'
  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/atoms/do_good_nav/do_good_nav'

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
      path: '/design'
      title: 'Design'
      handler: 'Legacy'

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'Design'}
  ]

  render: ->
    <LayoutDefault {...@props} cssModifier='-full-page'>
      <Breadcrumbs links=@breadcrumbs />
      <Design />
      <DoGoodNav omit='design' />
    </LayoutDefault>
