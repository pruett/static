[
  _
  React

  ProcessPage
  LayoutDefault

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/landing/process/process'
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
        '/process/{slug*}'
        '/california-transparency-act'
      ]

  receiveStoreChanges: -> [
    'landing'
  ]

  render: ->
    content = _.get (@getStore 'landing'), 'content'

    <LayoutDefault cssModifier='-full-width' {...@props}>
      {
        if not _.isEmpty content
          <ProcessPage {...content} />
      }
    </LayoutDefault>
