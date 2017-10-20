[
  _
  React

  LowBridgeFit
  LayoutDefault

  FrameHandlingMixin
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/landing/low_bridge_fit/low_bridge_fit'
  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/collections/frame_handling_mixin'
  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/low-bridge-fit'

  fetchVariations: [
    '/low-bridge-fit'
  ]

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
    FrameHandlingMixin
  ]

  statics:
    route: ->
      path: '/low-bridge-fit/women'
      handler: 'LowBridgeFit'
      title: 'Low Bridge Fit'

  render: ->
    content = @getContentVariation @CONTENT_PATH
    version = 'women'
    frames = _.get content, "frames[#{version}]"

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        if content
          <LowBridgeFit content=content version=version frames=frames />
      }
    </LayoutDefault>
