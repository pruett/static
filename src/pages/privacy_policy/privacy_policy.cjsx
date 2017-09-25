[
  _
  React

  LayoutDefault

  Breadcrumbs
  PlainDocument

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/static/plain_document/plain_document'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/privacy-policy'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/privacy-policy'
      title: 'Privacy Policy'
      handler: 'PrivacyPolicy'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'Privacy Policy'}
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault {...@props}>
      {if not @modifier('isMobileAppRequest')
        <Breadcrumbs links=@breadcrumbs />}
      <PlainDocument {...@props} content=content />
    </LayoutDefault>
