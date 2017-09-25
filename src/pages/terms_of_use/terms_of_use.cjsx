[
  _
  React
  #
  # LayoutDefault
  #
  # Breadcrumbs
  # PlainDocument
  #
  # Mixins
] = [
  require 'lodash'
  require 'react/addons'

  # require 'components/layouts/layout_default/layout_default'
  #
  # require 'components/atoms/breadcrumbs/breadcrumbs'
  # require 'components/organisms/static/plain_document/plain_document'
  #
  # require 'components/mixins/mixins'
]

module.exports = React.createClass
  # CONTENT_PATH: '/terms-of-use'
  #
  # mixins: [
  #   Mixins.context
  #   Mixins.dispatcher
  #   Mixins.routing
  # ]
  #
  # statics:
  #   route: ->
  #     path: '/terms-of-use'
  #     title: 'Terms of Use'
  #     handler: 'TermsOfUse'
  #
  # fetchVariations: -> [
  #   @CONTENT_PATH
  # ]
  #
  # breadcrumbs: [
  #   {text: 'Home', href: '/'}
  #   {text: 'Terms of Use'}
  # ]

  render: ->
    # content = @getContentVariation @CONTENT_PATH
    # console.log('props in component: ', @props)

    <p>hello terms of use</p>
