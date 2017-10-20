[
  _
  React

  LayoutDefault
  GiftCard

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/static/gift_card/gift_card'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  CONTENT_PATH: '/gift-card-responsive'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/gift-card'
      handler: 'GiftCard'
      title: 'Gift Card'

  receiveStoreChanges: -> [
    'giftCard'
    'session'
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  getInitialState: -> showFooter: false

  showFooter: -> @setState showFooter: true

  render: ->
    content = @getContentVariation(@CONTENT_PATH)

    return false if _.isEmpty content

    <LayoutDefault {...@props}
      showFooter=@state.showFooter
      cssModifier='-full-page'>

      <GiftCard {...content}
        session={@getStore('session')}
        giftCardErrors={@getStore('giftCard').formErrors}
        steps={[content.hero].concat content.steps}
        showFooter=@showFooter />

    </LayoutDefault>
