[
  _
  React

  LayoutDefault

  FlexibleSpendingAccounts

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/static/flexible_spending_accounts/flexible_spending_accounts'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/flexible-spending-accounts'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/flexible-spending-accounts'
      handler: 'FlexibleSpendingAccounts'
      title: 'Flexible Spending Accounts'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  receiveStoreChanges: ->
    ['geo']

  render: ->
    geo = @getStore 'geo'
    nearbyExams = _.some geo.nearbyStores, (store) ->
      store.info.offers_eye_exams

    <LayoutDefault {...@props}>
      <FlexibleSpendingAccounts
        {...@props}
        nearbyExams=nearbyExams
        content={@getContentVariation @CONTENT_PATH} />
    </LayoutDefault>
