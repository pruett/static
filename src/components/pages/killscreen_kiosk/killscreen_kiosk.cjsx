[
  _
  React

  LayoutBlank

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_blank/layout_blank'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.context
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/kill-screen-kiosk'
      handler: 'KillScreenKiosk'
      title: 'WP x KillScreen Kiosk'

  render: -> false
