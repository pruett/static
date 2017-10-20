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
      path: '/year-in-review-2014'
      handler: 'YearInReview2014'
      title: 'Year in Review 2014'

  render: -> false
