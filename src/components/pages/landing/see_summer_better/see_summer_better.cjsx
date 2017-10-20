[
  React

  Summer2016Editorial
  LayoutDefault

  Mixins
] = [
  require 'react/addons'

  require 'components/organisms/summer_2016_editorial/summer_2016_editorial'
  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/mixins'

  require '../../collections/summer_2016/summer_2016.scss'
]

module.exports = React.createClass
  CONTENT_PATH: '/see-summer-better'

  fetchVariations: [
    '/see-summer-better'
  ]

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/see-summer-better'
      handler: 'SeeSummerBetter'
      title: 'See Summer Better'

  render: ->
    content = @getContentVariation @CONTENT_PATH

    <LayoutDefault cssModifier='-full-page' {...@props}>
      {
        if content
          <Summer2016Editorial content=content />
      }
    </LayoutDefault>
