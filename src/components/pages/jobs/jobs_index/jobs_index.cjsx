[
  _
  React

  Jobs
  LayoutDefault

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/jobs/jobs'
  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      bundle: 'jobs'
      handler: 'Jobs'
      path: '/jobs/{job_type?}'
      title: 'Jobs'
      visibleBeforeMount: true

  receiveStoreChanges: -> [
    'jobs'
  ]

  render: ->
    data = @getStore 'jobs'
    cleanedData = _.omit data, '__fetched'

    <LayoutDefault {...@props} cssModifier='-full-page'>
      {if data.__fetched
        <Jobs {...cleanedData} />
      }
    </LayoutDefault>
