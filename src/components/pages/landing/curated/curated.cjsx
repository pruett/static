[
  _
  React

  LayoutDefault

  CuratedPage

  Mixins
  CuratedMixin

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/landing/curated/curated'

  require 'components/mixins/mixins'
  require 'components/mixins/curated_mixin'
]

module.exports = React.createClass

  mixins: [
    CuratedMixin
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      handler: 'LandingPage'
      path: [
        '/eyeglasses/{slug*}'
        '/sunglasses/{slug*}'
      ]

  receiveStoreChanges: -> [
    'landing'
  ]

  render: ->
    content = _.get (@getStore 'landing'), 'content'
    contentCurated = @mergeProductsIntoContent content

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        if not _.isEmpty contentCurated
          <CuratedPage {...contentCurated} />
      }
    </LayoutDefault>
