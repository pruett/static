[
  React
  _

  LayoutDefault
  CuratedPage

  Mixins
  CuratedMixin
] = [
  require 'react/addons'
  require 'lodash'

  require 'components/layouts/layout_default/layout_default'
  require 'components/organisms/landing/curated/curated'

  require 'components/mixins/mixins'
  require 'components/mixins/curated_mixin'

]

module.exports = React.createClass

  mixins: [
    CuratedMixin
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  CONTENT_PATH: '/landing-page/fall-2016/fall-palette'

  statics:
    route: ->
      path: '/fall-2016/fall-palette'
      handler: 'Fall2016FallPalette'
      title: 'Warby Parker Fall 2016 Fall Palette'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH
    contentCurated = @mergeProductsIntoContent content

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        if not _.isEmpty contentCurated
          <CuratedPage {...contentCurated} />
      }
    </LayoutDefault>
