[
  _
  React

  EyeExams

  LayoutDefault

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/appointments/eye_exams/eye_exams'

  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/retail/eye-exams'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/appointments/eye-exams'
      handler: 'EyeExams'
      title: 'Book an eye exam'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'retail'
  ]

  getEyeExamLocations: (allLocations) ->
    _.filter allLocations, offers_eye_exams: true

  render: ->
    retail = @getStore 'retail'
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault {...@props}>
      {if retail and content
        <EyeExams
          locations={@getEyeExamLocations retail.locations}
          content=content />
      }
    </LayoutDefault>
