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
      path: '/annual-report-2014'
      handler: 'AnnualReport2014'
      title: 'Annual Report 2014'

  render: -> false
