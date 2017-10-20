[
  _
  React

  HeroShort
  LocalBusinessSchema

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/heroes/short/short'
  require 'components/atoms/structured_data/local_business/local_business'

  require 'components/mixins/mixins'

  require './eye_exams.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-eye-exams'

  mixins: [
    Mixins.classes
    Mixins.analytics
    Mixins.context
  ]

  propTypes:
    locations: React.PropTypes.array
    content: React.PropTypes.object

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-mln18 u-mrn18
      u-pb48"
    content:
      'u-grid -maxed
      u-mla u-mra
      u-pl18 u-pr18'
    introText:
      'u-grid__row -center
      u-pt48 u-pb48 u-pb60--600'
    introTextHeading:
      'u-grid__col u-w12c
      u-reset u-fs30 u-fs50--600 u-fs60--900 u-mb24
      u-tac
      u-ffs
      u-fws
      u-mb12'
    introTextBody:
      'u-grid__col u-w12c -c-8--600 -c-6-900
      u-reset u-fs16 u-fs18--900
      u-tac'
    regionGroup:
      "#{@BLOCK_CLASS}__region-group
      u-mb36--900"
    locationGroup:
      "#{@BLOCK_CLASS}__location-group
      u-dib
      u-w100p
      u-mb36"
    regionName:
      "#{@BLOCK_CLASS}__region-name
      u-reset u-fs20 u-fs24--600
      u-ffs
      u-fws"
    locationDetail:
      "#{@BLOCK_CLASS}__location-detail
      u-reset u-fs16 u-mb24"
    address:
      'u-color--dark-gray-alt-2'
    hr:
      "#{@BLOCK_CLASS}__hr
      u-hr"
    footer:
      'u-grid__row -center
      u-ml12 u-mr12 u-mb18--900
      u-pt48
      u-tac'
    footerImage:
      'u-mb12'
    footerTitle:
      "#{@BLOCK_CLASS}__footer-title
      u-grid__col u-w12c
      u-reset u-fs16
      u-ttu
      u-fwn"
    footerDesc:
      'u-grid__col u-w12c -c-10--600 -c-8--900
      u-reset u-fs16'

  getBannerImages: (sources) ->
    return [] unless _.isArray sources

    sources = _.sortBy(sources, 'min_viewport_width').reverse()

    sources.map (src) ->
      url: src.url
      mediaQuery: "(min-width: #{src.min_viewport_width}px)"
      sizes: "#{src.relative_image_width}vw"
      widths: _.range(
        parseInt(src.min_image_width)
        parseInt(src.max_image_width) + 1
        200
      )

  sortLocations: (all) ->
    # Map the flat array of locations into a country-keyed object containing
    # arrays of locations grouped and ordered by state/region name.

    byCountry = _.groupBy all, 'address.country_code'

    _.mapValues byCountry, (countryLocs) ->
      byRegion = _.groupBy countryLocs, 'address.region_name'
      byRegionSorted = _.sortBy byRegion, (loc, region) -> region

      _.map byRegionSorted, (regionLocs) ->
        _.sortBy regionLocs, (loc) -> loc.address.locality

  renderCountry: (locations, country) ->
    if locations[country]
      <section key=country className=@classes.regionGroup
        children={_.map locations[country], @renderRegion} />

  renderRegion: (regionLocations, i) ->
    <div key=i className=@classes.locationGroup>
      <h2 className=@classes.regionName
        children={_.get regionLocations, '[0].address.region_name'} />

      {_.map regionLocations, @renderLocation}
    </div>

  renderLocation: (loc, i) ->
    address = _.get loc, 'address', {}
    cmsContent = _.get loc, 'cms_content'

    locName =
      if cmsContent
        <a children=cmsContent.name
          href="/appointments/eye-exams/#{loc.city_slug}/#{loc.location_slug}" />
      else
        <span children=cmsContent.name />

    <div>
      <p key=i className=@classes.locationDetail>
        <span children={[address.locality, ', ', locName]} />
        <br />
        <span className=@classes.address children=address.street_address />
        <br />
        <span className=@classes.address children=cmsContent.neighborhood />
      </p>

      <LocalBusinessSchema
        address={{
          streetAddress: address.extended_address,
          addressLocality: address.locality,
          addressRegion: address.region_code,
          postalCode: address.postal_code,
          addressCountry: address.country_code
        }}
        description={_.get @props.content, 'intro_text.body', ''}
        geo={{
          latitude: _.get(cmsContent, 'map_details', {}).latitude,
          longitude: _.get(cmsContent, 'map_details', {}).longitude
        }}
        hasMap={_.get(cmsContent, 'map_details', {}).url}
        image={_.get(cmsContent, 'hero_image[0]', []).image}
        name={cmsContent.name}
        openingHours={_.get(loc, 'schedules', {})}
        priceRange={'$75'}
        telephone={cmsContent.phone}
        type={'Optician'},
        url={"/appointments/eye-exams/#{loc.city_slug}/#{loc.location_slug}"}
      />
    </div>

  handleInsuranceLinkClick: ->
    @trackInteraction 'eyeExamsIndex-clickLink-insurance'

  render: ->
    {locations, content} = _.pick @props, 'locations', 'content'
    return false unless locations and content

    introText =
      heading: _.get content, 'intro_text.heading', 'Book an eye exam'
      body: _.get content, 'intro_text.body'
    locations = @sortLocations locations
    footer = content.footer

    @classes = @getClasses()

    <div className=@classes.block>
      <HeroShort
        alt=content.hero.alt_text
        sources={@getBannerImages _.get(content, 'hero.sources', {})} />

      <section className=@classes.content>
        <div className=@classes.introText>
          <h1 className=@classes.introTextHeading
            children=introText.heading />
          {if introText.body
            <p className=@classes.introTextBody
              children=introText.body />
          }
          <div className='u-pt24'>
            <span
              children='Find out how to apply for insurance reimbursement'
              className=' u-reset u-fs16 u-fws u-color--dark-gray' />
            <a
              children=' here'
              href='/insurance'
              onClick=@handleInsuranceLinkClick
              className='u-fws u-fs16' />
          </div>
        </div>

        {_.map content.country_order, @renderCountry.bind(@, locations)}

        <hr className=@classes.hr />

        {if footer
          image = footer.image or {}

          <div className=@classes.footer>
            {unless _.isEmpty image.svg
              svg = image.svg

              <svg className=@classes.footerImage
                viewBox=svg.view_box
                {...svg}>
                <title children=image.alt />
                <g children={image.svg.paths.map (path) -> <path d=path />} />
              </svg>

            else if image.url
              <img className=@classes.footerImage
                src=image.url
                alt=image.alt />
            }

            <h3 className=@classes.footerTitle children=footer.heading />
            <p className=@classes.footerDesc children=footer.body />
          </div>
        }
      </section>
    </div>
