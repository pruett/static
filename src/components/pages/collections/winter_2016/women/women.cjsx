React = require 'react/addons'
_ = require 'lodash'

Winter2016 = require 'components/organisms/collections/winter_2016/winter_2016'

LayoutDefault = require 'components/layouts/layout_default/layout_default'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/landing-page/winter-2016'

  EXPERIMENT_TO_VERSION:
    showWomenA:
      version: 'f'
      heroVariant: 'womenA'
    showWomenB:
      version: 'f'
      heroVariant: 'womenB'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/winter-2016/women'
      handler: 'Winter2016'
      title: 'Winter 2016'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    renderProps = @EXPERIMENT_TO_VERSION['showWomenA']
    segmentationState = @getExperimentState 'winterLandingPageSegmentationW'

    if segmentationState and segmentationState.participant
      renderProps = _.get @EXPERIMENT_TO_VERSION, segmentationState.variant, renderProps

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        unless _.isEmpty content
          <Winter2016 {...content} {...renderProps} />
      }
    </LayoutDefault>
