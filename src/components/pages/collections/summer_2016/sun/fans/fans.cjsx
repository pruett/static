[
  React
  _

  LayoutDefault
  SummerGallery

  Mixins
] = [
  require 'react/addons'
  require 'lodash'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/collections/summer_2016/gallery/gallery'

  require 'components/mixins/mixins'

  require '../../summer_2016.scss'
]

module.exports = React.createClass
  CONTENT_PATH: '/summer-2016'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/summer-2016/sun'
      handler: 'Summer2016'
      title: 'Summer 2016'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        unless _.isEmpty content
          <SummerGallery content=content version='fans' frameType='sun' />
      }
    </LayoutDefault>
