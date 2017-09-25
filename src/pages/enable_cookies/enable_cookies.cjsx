[
  _
  React

  LayoutDefault

  Breadcrumbs
  EnableCookies

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/static/enable_cookies/enable_cookies'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/enable_cookies'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/enable_cookies'
      title: 'Enable Cookies'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  breadcrumbs: [
    {text: 'Home', href: '/'}
    {text: 'Enable Cookies'}
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault {...@props}>
      <Breadcrumbs
        links=@breadcrumbs />

      <EnableCookies
        {...@props}
        content=content />
    </LayoutDefault>
