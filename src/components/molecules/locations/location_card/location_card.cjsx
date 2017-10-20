[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './location_card.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-location-card'

  mixins: [
    Mixins.classes
    Mixins.analytics
  ]

  propTypes:
    location: React.PropTypes.object
    cssModifier: React.PropTypes.string
    locationSlug: React.PropTypes.string
    showExtendedAddress: React.PropTypes.bool

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}"
    image:
      "#{@BLOCK_CLASS}__image"
    heading:
      @props.cssModifierHeading
    body:
      @props.cssModifierBody

  render: ->
    classes = @getClasses()
    loc = @props.location
    return unless loc and loc.cms_content

    locationSlug = _.camelCase(@props.locationSlug) ? "locationCardUnspecified"
    showExtendedAddress = @props.showExtendedAddress ? true

    analyticsIdImg = "favorites-clickStoreImg-#{locationSlug}"
    analyticsIdLink = "favorites-clickStoreLink-#{locationSlug}"

    <section className=classes.block>
      <a href="/retail/#{loc.city_slug}/#{loc.location_slug}">
        <Img cssModifier=classes.image
          src=loc.cms_content.card_photo
          onClick={@trackInteraction.bind @, analyticsIdImg} />

        <h3 className=classes.heading
          children=loc.cms_content.name 
          onClick={@trackInteraction.bind @, analyticsIdLink} />
      </a>

      <p className=classes.body>
        <span children=loc.address.street_address />
        <br />
        {if loc.address.extended_address and showExtendedAddress
          [
            <span key='address' children=loc.address.extended_address />
            <br key='br' />
          ]
        }
        <span children="#{loc.address.locality}, #{loc.address.region_code}
          #{loc.address.postal_code}" />
      </p>
    </section>
