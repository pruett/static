[
  _
  React

  LayoutDefault
  BuyAPairGiveAPair

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/static/buy_a_pair_give_a_pair/buy_a_pair_give_a_pair'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  displayName: 'PagesBuyAPairGiveAPair',

  CONTENT_PATH: '/buy-a-pair-give-a-pair'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/buy-a-pair-give-a-pair'
      title: 'Buy a Pair, Give a Pair'
      handler: 'BuyAPairGiveAPair'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault {...@props} cssModifier='-full-page u-btw1 u-btss u-bc--light-gray'>
      <BuyAPairGiveAPair {...content} />
    </LayoutDefault>
