[
  _
  React

  Breadcrumbs
  CTA
  Img
  StaticGoogleMap
  LocationsLocationCard
  LocationsMarquee
  LocationsScheduleList
  LocationsServiceCard
  LocationsStructuredMarkup
  Urls

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'
  require 'components/atoms/maps/google/static/static'
  require 'components/molecules/locations/location_card/location_card'
  require 'components/molecules/locations/marquee/marquee'
  require 'components/molecules/locations/schedule_list/schedule_list'
  require 'components/molecules/locations/service_card/service_card'
  require 'components/molecules/locations/structured_markup/structured_markup'
  require 'components/utilities/urls'

  require 'components/mixins/mixins'

  require './location.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-location'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    location: React.PropTypes.shape
      name: React.PropTypes.string
      schedules: React.PropTypes.arrayOf React.PropTypes.object
      address: React.PropTypes.shape
        street_address: React.PropTypes.string
        extended_address: React.PropTypes.string
        locality: React.PropTypes.string
        region_code: React.PropTypes.string
        region_name: React.PropTypes.string
        country_code: React.PropTypes.string
        postal_code: React.PropTypes.oneOfType [
          React.PropTypes.string
          React.PropTypes.number
        ]
      telephone: React.PropTypes.string
      timezone_offset: React.PropTypes.string
      location_slug: React.PropTypes.string
      facility_slug: React.PropTypes.string
      cms_content: React.PropTypes.shape
        hero_image: React.PropTypes.array
        name: React.PropTypes.string
        description: React.PropTypes.string
        phone: React.PropTypes.string
        hours_note: React.PropTypes.string
        map_details: React.PropTypes.shape
          latitude: React.PropTypes.oneOfType [
            React.PropTypes.string
            React.PropTypes.number
          ]
          longitude: React.PropTypes.oneOfType [
            React.PropTypes.string
            React.PropTypes.number
          ]
          url: React.PropTypes.string
        services: React.PropTypes.array
        callout: React.PropTypes.shape
          intro_text: React.PropTypes.string
          cta_url: React.PropTypes.string
          cta_text: React.PropTypes.string
          hide_on_mobile: React.PropTypes.bool
        card_photo: React.PropTypes.string
    nearbyLocations: React.PropTypes.array
    currentStatus: React.PropTypes.string
    isOpenDaily: React.PropTypes.bool
    services: React.PropTypes.array
    shopLinks: React.PropTypes.object

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    marquee:
      "#{@BLOCK_CLASS}__marquee"
    locationName:
      "#{@BLOCK_CLASS}__location-name
      u-reset u-ffs u-fws
      u-tac"
    outerGrid:
      "#{@BLOCK_CLASS}__outer-grid
      u-grid
      u-tac"
    innerGrid:
      "#{@BLOCK_CLASS}__inner-grid"
    hr:
      "#{@BLOCK_CLASS}__hr
      u-hr"
    hrDashed:
      "#{@BLOCK_CLASS}__hr -dashed
      u-hr"
    overview:
      "#{@BLOCK_CLASS}__overview
      u-grid__row -center"
    addressSchedules:
      "#{@BLOCK_CLASS}__address-schedule
      u-grid__col u-w12c -c-6--600"
    address:
      "#{@BLOCK_CLASS}__address
      u-reset"
    schedules:
      'u-grid__row'
    schedulesContainer:
      'u-grid__col -c-8 -c-10--600'
    hoursNote:
      "#{@BLOCK_CLASS}__hours-note
      u-reset
      u-color--dark-gray-alt-2"
    map:
      'u-grid__col u-w12c -c-6--600'
    mapLink:
      "#{@BLOCK_CLASS}__map-link
      u-reset
      u-tal"
    calloutContainer: ''
    callout:
      "#{@BLOCK_CLASS}__callout
      u-tac
      u-grid__row"
    calloutIntroText:
      "#{@BLOCK_CLASS}__callout-intro-text
      u-reset -margin
      u-grid__col u-w12c -c-10--600 -center"
    calloutCta:
      "#{@BLOCK_CLASS}__callout-cta"
    services:
      "#{@BLOCK_CLASS}__services
      u-grid__row -center"
    serviceCard:
      "#{@BLOCK_CLASS}__service-card
      u-grid__col u-w12c"
    storePhotos:
      'u-grid__row'
    storePhoto:
      "#{@BLOCK_CLASS}__store-photo
      u-grid__col u-w12c"
    description:
      'u-color-bg--light-gray-alt-2'
    about:
      "#{@BLOCK_CLASS}__about
      u-tac
      u-grid__row"
    aboutHeading:
      "#{@BLOCK_CLASS}__about-heading
      u-reset u-ffs u-fws -margin
      u-grid__col u-w12c -c-10--600"
    aboutHr:
      "#{@BLOCK_CLASS}__about-hr"
    aboutBody:
      "#{@BLOCK_CLASS}__about-body
      u-reset u-ffs
      u-grid__col -c-10 -c-8--900"
    shopLinks:
      "#{@BLOCK_CLASS}__shop-links
      u-grid__row
      u-tac"
    shopLinksHeading:
      "#{@BLOCK_CLASS}__shop-links-heading
      u-reset u-ffs u-fws -margin
      u-grid__col u-w12c"
    shopLinksHeadingText:
      "#{@BLOCK_CLASS}__shop-links-heading-text
      u-color-bg--white"
    shopLink:
      "#{@BLOCK_CLASS}__shop-link
      u-grid__col -c-10 -c-6--600"
    shopLinkText:
      "#{@BLOCK_CLASS}__shop-link-text
      u-reset u-fs16 u-ttu
      u-color--dark-gray"
    nearbyLocations:
      "#{@BLOCK_CLASS}__nearby-locations
      u-tac
      u-grid__row
      u-bc--light-gray"
    nearbyLocationsCards:
      'u-tac u-tal--600'
    nearbyLocationsCard:
      "#{@BLOCK_CLASS}__nearby-locations-card
      u-grid__col u-w12c -c-6--600"
    nearbyLocationsHeading:
      "#{@BLOCK_CLASS}__nearby-locations-heading
      u-reset u-ffs u-fws -margin"
    nearbyLocationsHeadingText:
      "#{@BLOCK_CLASS}__nearby-locations-heading-text
      u-color-bg--white"
    allLocationsCta:
      "#{@BLOCK_CLASS}__all-locations-cta"
    locationsHeading:
      'u-reset u-fs24 -margin u-ffs u-fwn'
    locationsBody:
      'u-reset u-fs16'

  classesWillUpdate: ->
    hideCalloutOnMobile = _.get @props,
      'location.cms_content.callout.hide_on_mobile', false
    servicesCount = @getServicesCount()

    serviceCard:
      "-c-#{Math.floor(12/servicesCount)}--900": true
    calloutContainer:
      'u-dn': hideCalloutOnMobile
      'u-db--720': hideCalloutOnMobile

  getServicesCount: ->
    _.get(@props, 'location.cms_content.services', []).length

  renderAddress: (address, phone) ->
    <p className=@classes.address key='address'>
      <span key='street-address'
        className=@classes.addressLine
        children=address.street_address />
      <br key='street-address-br' />

      {if address.extended_address
        [
          <span key='extended-address'
            className=@classes.addressLine
            children=address.extended_address />
          <br key='extended-address-br' />
        ]
      }

      <span key='city-state-zip'
        className=@classes.addressLine
        children="#{address.locality}, #{address.region_code}
          #{address.postal_code}" />

      {if phone
        [
          <br key='phone-br' />
          <a key='phone'
            href="tel:+1-#{_.kebabCase phone}"
            onClick={@trackInteraction.bind @, 'retail-click-phoneNumber'}
            className=@classes.addressLine
            children=phone />
        ]
      }
    </p>

  renderSchedules: (schedules) ->
    <section key='schedules' className=@classes.schedules>
      <LocationsScheduleList
        schedules=schedules
        currentStatus=@props.currentStatus
        isOpenDaily=@props.isOpenDaily
        cssModifier=@classes.schedulesContainer />
    </section>

  renderHoursNote: (hoursNote) ->
    <p className=@classes.hoursNote
      children=hoursNote />

  renderMap: (mapDetails) ->
    <div key='map' className=@classes.map>
      <a href=mapDetails.url
        target='_blank'
        onClick={@trackInteraction.bind @, 'retail-click-mapImage'}>
        <StaticGoogleMap
          key='map'
          markers="color:0x00a2e1|
            #{mapDetails.latitude},#{mapDetails.longitude}"
          zoom=15 scale=2 />
      </a>
      <a href=mapDetails.url
        target='_blank'
        onClick={@trackInteraction.bind @, 'retail-click-viewMap'}>
        <p key='text'
          className=@classes.mapLink
          children='View on map' />
      </a>
    </div>

  renderCallout: (callout) ->
    return [] unless callout.intro_text or (callout.cta_text and callout.cta_url)

    <div className=@classes.calloutContainer>
      <hr key='callout-hr'
        className=@classes.hrDashed />
      <div key='callout-grid'
        className=@classes.innerGrid>
        <section className=@classes.callout>
          {if callout.intro_text
            <p key='intro-text'
              className=@classes.calloutIntroText
              children=callout.intro_text />
          }
          {if callout.cta_text and callout.cta_url
            <CTA key='cta'
              cssModifier=@classes.calloutCta
              analyticsSlug='retail-click-calloutCta'
              tagName='a'
              variation='primary'
              children=callout.cta_text
              href=Urls.relativeLinkFor(callout.cta_url) />
          }
        </section>
      </div>
    </div>

  renderServices: (services) ->
    [
      <hr key='services-hr'
        className=@classes.hrDashed />
      <div key='service-grid'
        className=@classes.innerGrid>
        <section className=@classes.services
          children={_.map services, @renderServiceCard} />
      </div>
    ]

  renderServiceCard: (service, i) ->
    props = _.find @props.services, slug: service

    <LocationsServiceCard {...props}
      key=i
      cssModifier=@classes.serviceCard />

  renderStorePhotos: (storePhotos) ->
    <section key='store-photos' className=@classes.storePhotos
      children={_.map storePhotos, @renderStorePhoto} />

  renderDescription: (cmsContent, loc, description) ->
    name = @getAboutSectionName(cmsContent, loc)
    <div key='about' className=@classes.description>
      <section className=@classes.about>
        <h3 className=@classes.aboutHeading
          children="About #{name}" />
        <hr className=@classes.aboutHr />
        <p key='about-body'
          className=@classes.aboutBody
          children=description />
      </section>
    </div>

  renderStorePhoto: (url, i) ->
    <Img key=i
      cssModifier=@classes.storePhoto
      srcSet={@getSrcSet {url, widths: _.range 280, 1820, 200}} />

  renderShopLinks: (shopLinks) ->
    [
      <h3 key='shop-links-heading'
        className=@classes.shopLinksHeading>
        <span className=@classes.shopLinksHeadingText
          children=shopLinks.heading />
      </h3>
      <div key='shop-links' className=@classes.innerGrid>
        <section className=@classes.shopLinks>
          {_.map shopLinks.links, @renderShopLink}
        </section>
      </div>
    ]

  renderShopLink: (link, i) ->
    <a key=i
      href=link.url
      className=@classes.shopLink
      onClick={@trackInteraction.bind @, "retail-click-shopFrames#{i + 1}"}>
      <p key='link-text'
        className=@classes.shopLinkText
        children=link.text />
      <img src=link.image />
    </a>

  renderNearbyLocations: (locations) ->
    [
      <h3 key='nearby-locations-heading'
        className=@classes.nearbyLocationsHeading>
        <span className=@classes.nearbyLocationsHeadingText
          children='Other nearby locations' />
      </h3>
      <div key='nearby-locations'
        className=@classes.innerGrid>
        <section className=@classes.nearbyLocations>
          <div className=@classes.nearbyLocationsCards
            children={locations.map @renderLocationCard} />
        </section>
      </div>
    ]

  renderLocationCard: (loc, i) ->
    <LocationsLocationCard
      key=i
      location=loc
      cssModifier=@classes.nearbyLocationsCard
      cssModifierHeading=@classes.locationsHeading
      cssModifierBody=@classes.locationsBody />

  renderHeader: (cmsContent, loc) ->
    <h1 className=@classes.locationName
      children={cmsContent.name or loc.name}
    />

  getAboutSectionName: (cmsContent, loc) ->
    cmsContent.name_about or cmsContent.name or loc.name

  render: ->
    loc = @props.location
    services = @props.services
    return false unless loc and services

    @classes = @getClasses()
    cmsContent = loc.cms_content

    <section className=@classes.block>
      <Breadcrumbs
        links=@props.breadcrumbs
        cssModifier='-over-hero' />

      <LocationsMarquee
        cssModifier=@classes.marquee
        sources=cmsContent.hero_image
        alt=cmsContent.name />

      {@renderHeader(cmsContent, loc)}

      <div className=@classes.outerGrid>
        <div className=@classes.innerGrid key='attributes'>
          <section className=@classes.overview>
            <div className=@classes.addressSchedules>
              {@renderAddress(loc.address, cmsContent.phone) if loc.address}
              {@renderSchedules(loc.schedules) if loc.schedules}
              {@renderHoursNote(cmsContent.hours_note) if cmsContent.hours_note}
            </div>

            {@renderMap(cmsContent.map_details) if cmsContent.map_details}
          </section>
        </div>

        {@renderCallout(cmsContent.callout) if cmsContent.callout}

        {@renderServices(cmsContent.services) unless _.isEmpty cmsContent.services}

        {@renderStorePhotos(cmsContent.store_photos) unless _.isEmpty cmsContent.store_photos}

        {@renderDescription(cmsContent, loc, cmsContent.description) if cmsContent.description}

        {@renderShopLinks(@props.shopLinks) unless _.isEmpty @props.shopLinks}

        {@renderNearbyLocations(@props.nearbyLocations) unless _.isEmpty @props.nearbyLocations}

        <hr key='all-locations-hr'
          className=@classes.hr />
        <CTA key='all-locations'
          tagName='a'
          cssModifier=@classes.allLocationsCta
          variation='primary'
          href='/retail'
          analyticsSlug='retail-click-allLocations'
          children='See all locations' />
      </div>

      <LocationsStructuredMarkup
        location=loc
        cmsContent=cmsContent />
    </section>
