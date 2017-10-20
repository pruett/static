[
  React

  LayoutDefault

  RetailLocations

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/locations/all_locations/all_locations'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  CONTENT_PATH: '/retail/locations'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.routing
  ]

  statics:
    route: ->
      path: '/retail'
      handler: 'Locations'
      title: 'Retail Locations'

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  receiveStoreChanges: -> [
    'retail'
  ]

  inCanada: ->
    @getLocale().country is 'CA'

  render: ->
    retail = @getStore 'retail'
    content = @getContentVariation @CONTENT_PATH
    {locations, locationsEyeExam} = retail

    # By default, we want to show US retail locations
    # first, followed by CA; if we recongnize a visitor
    # from Canada, we'll reverse this behavior
    #
    # Default: content.country_order: ["US", "CA"]

    if content and @inCanada()
      content.country_order = ['CA', 'US']

    <LayoutDefault {...@props}>
      {if retail and content
        <RetailLocations
          {...@props}
          locations=locations
          locationsEyeExam=locationsEyeExam
          content=content
          breadcrumbs={[text: 'Locations']} />
      }
    </LayoutDefault>
