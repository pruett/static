[
  _
  React

  GalleryPage
  LayoutDefault

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/landing/gallery/gallery'
  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      handler: 'LandingPage'
      path: [
        '/eyeglasses/all/{slug*}'
        '/sunglasses/all/{slug*}'
      ]

  receiveStoreChanges: -> [
    'landing'
  ]

  render: ->
    content = _.get (@getStore 'landing'), 'content'
    <LayoutDefault cssModifier='-full-width' {...@props}>
      {
        if not _.isEmpty content
          <GalleryPage content=content />
      }
    </LayoutDefault>
