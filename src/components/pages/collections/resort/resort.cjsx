React = require 'react/addons'
_ = require 'lodash'

LayoutDefault = require 'components/layouts/layout_default/layout_default'
Resort = require 'components/organisms/collections/resort/resort'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  CONTENT_PATH: '/landing-page/resort'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/resort'
      handler: 'Resort'
      title: 'Warby Parker Resort Collection'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  render: ->
    content = @getContentVariation @CONTENT_PATH
    <div className='c-killscreen__parallax'>
      <LayoutDefault cssModifier='-full-page' {...@props}>
        {
          unless _.isEmpty content
            <Resort {...content} />
        }
      </LayoutDefault>
    </div>
