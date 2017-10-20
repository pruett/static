[
  _
  React

  LayoutDefault

  History
  Breadcrumbs
  DoGoodNav

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/history/history'
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
      path: '/history'
      title: 'History'
      handler: 'Legacy'

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'History'}
  ]

  render: ->
    <LayoutDefault {...@props} cssModifier='-full-page'>
      <Breadcrumbs links=@breadcrumbs />
      <History />
      <DoGoodNav omit='history' />
    </LayoutDefault>
