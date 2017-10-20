[
  _
  React
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'
]

# This component takes location information from our facility data and CMS,
# and produces structured markup in JSON-LD form, as per the LocalBusiness
# spec.  See http://schema.org/LocalBusiness.

module.exports = React.createClass
  mixins: [
    Mixins.context
  ]

  propTypes:
    location: React.PropTypes.object
    cmsContent: React.PropTypes.object

  getStoreHours: (schedules) ->
    _.find schedules, name: 'Store'

  formatHours: (schedule) ->
    # http://schema.org/openingHours
    return '' unless (schedule and schedule.hours)

    _.map schedule.hours, (hours, day) =>
      return unless hours.open and hours.close and day

      day = _.startCase day.slice 0, 2
      open = @formatTimeString hours.open
      close = @formatTimeString hours.close
      return unless open and close

      "#{day} #{open}-#{close}"

  formatTimeString: (string) ->
    pieces = string.split ':'
    return null unless pieces.length > 1

    hours = pieces[0]
    if string.match /p\.?m/gi
      hours = parseInt(hours) + 12

    minutesTimeOfDay = pieces[1].split /(\s|a|p)/gi
    return null unless minutesTimeOfDay.length > 1

    minutes = minutesTimeOfDay[0]

    "#{hours}:#{minutes}"

  render: ->
    loc = @props.location or {}
    address = loc.address or {}
    cmsContent = @props.cmsContent or {}
    mapDetails = cmsContent.map_details or {}

    imageURL = _.get cmsContent, 'hero_image[0].image', ''
    if imageURL.length and !_.startsWith imageURL, 'http'
      imageURL = 'https:' + imageURL

    priceRange = _.get cmsContent, 'priceRange', ''
    if _.isEmpty priceRange
      priceRange = 'Starting at $' + (parseInt(@getFeature('basePriceCents'), 10) / 100).toFixed()

    <script type='application/ld+json'
      dangerouslySetInnerHTML={__html: JSON.stringify(
        '@context': 'http://schema.org'
        '@type': 'LocalBusiness'
        address:
          '@type': 'PostalAddress'
          addressLocality: address.locality
          addressRegion: address.region_code
          streetAddress: address.street_address
        description: cmsContent.description
        name: cmsContent.name
        telephone: cmsContent.phone
        brand: 'Warby Parker'
        photo:
          '@type': 'Photograph'
          url: imageURL
        image: imageURL
        priceRange: priceRange
        hasMap: mapDetails.url
        geo:
          '@type': 'GeoCoordinates'
          latitude: mapDetails.latitude
          longitude: mapDetails.longitude
        openingHours: @formatHours @getStoreHours loc.schedules
      )} />
