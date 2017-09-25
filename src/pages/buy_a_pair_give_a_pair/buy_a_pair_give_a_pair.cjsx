[
  _
  React

  LayoutDefault

  Bapgap
  Breadcrumbs
  DoGoodNav

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/buy_a_pair_give_a_pair/buy_a_pair_give_a_pair'
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
      path: '/buy-a-pair-give-a-pair'
      title: 'Buy A Pair, Give A Pair'
      handler: 'Legacy'

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'Buy A Pair, Give A Pair'}
  ]

  render: ->
    <LayoutDefault {...@props} cssModifier='-full-page'>
      <Breadcrumbs links=@breadcrumbs />
      <Bapgap />
      <DoGoodNav omit='bapgap' />
    </LayoutDefault>
