[
  _
  React

  LayoutDefault

  StaticFAQ

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/molecules/static_faq/static_faq'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/responsive/help'

  statics:
    route: ->
      path: '/help/faqs'
      handler: 'Help'
      title: 'FAQs'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  getData: ->
    params = _.get @props, 'appState.location.query', {}
    content = @getContentVariation @CONTENT_PATH
    data = _.get(content, 'help_topics', [])
    topic = _.get(params, 'topic', false)
    if topic
      data = _.filter(data, { 'tab_id': topic })
    data

  render: ->
    data = @getData()

    <LayoutDefault {...@props} cssModifier="-full-width">
      {_.map data, (topic, i, topics) ->
          section =
            section_id:    topic.tab_id
            section_title: topic.topic
            section_faqs:  topic.q_and_a

          <StaticFAQ key=i
            section=section
            isLast={topics.length - 1 is i} />}
    </LayoutDefault>