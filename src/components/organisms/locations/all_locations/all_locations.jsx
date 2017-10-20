const _ = require('lodash')
const React = require('react/addons')
const Checkbox = require('components/atoms/forms/checkbox/checkbox')
const Breadcrumbs = require('components/atoms/breadcrumbs/breadcrumbs')
const CTA = require('components/atoms/buttons/cta/cta')
const HeroShort = require('components/molecules/heroes/short/short')
const Mixins = require('components/mixins/mixins')
const LocalBusinessSchema = require('components/atoms/structured_data/local_business/local_business')

require('./all_locations.scss')

module.exports = React.createClass({
  displayName: 'OrganismsAllLocations',

  BLOCK_CLASS: 'c-all-locations',

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context
  ],

  propTypes: {
    breadcrumbs: React.PropTypes.array,
    content: React.PropTypes.object,
    locations: React.PropTypes.array,
    locationsEyeExam: React.PropTypes.array
  },

  getInitialState: function () {
    return {filterByEyeExamAvailability: false};
  },

  getStaticClasses: function () {
    return {
      block: this.BLOCK_CLASS,
      bannerImage: `${this.BLOCK_CLASS}__banner-image`,
      countryGroup: `${this.BLOCK_CLASS}__country-group`,
      countryName: `
          ${this.BLOCK_CLASS}__country-name
          u-tac
          u-ffs
          u-fws
          u-mb24
      `,
      countryNameFirst: `
        ${this.BLOCK_CLASS}__country-name -first
        u-tac
        u-ffs
        u-fws
      `,
      eyeExamToggle: `u-df u-flexd--c u-ai--c u-mtn48 u-mb48`,
      eyeExamTitle: `u-fs16 u-fs18--900 u-fwn u-ffss u-mt24 u-mb8`,
      eyeExamInfo: `
          ${this.BLOCK_CLASS}__eye-exam-info
          u-fs16 u-fwn u-ffss u-mt30 u-mb24 u-tac
      `,
      regionGroup: `${this.BLOCK_CLASS}__region-group`,
      locationGroup: `${this.BLOCK_CLASS}__location-group`,
      regionName: `
          ${this.BLOCK_CLASS}__region-name
          u-reset u-ffs u-fws
      `,
      locationDetail: `
        ${this.BLOCK_CLASS}__location-detail
        u-reset u-fs16
      `,
      cityName: `${this.BLOCK_CLASS}__city-name`,
      address: `${this.BLOCK_CLASS}__address`,
      hr: `${this.BLOCK_CLASS}__hr`,
      footer: `${this.BLOCK_CLASS}__footer`,
      eyeExamFooter: `
        ${this.BLOCK_CLASS}__eye-exam-footer
        u-m0a u-tac
      `,
      footerTitle: `
        ${this.BLOCK_CLASS}__footer-title
        u-reset u-ffs u-fws u-fs24 u-mb12
      `,
      footerDesc: `
        ${this.BLOCK_CLASS}__footer-desc
        u-reset u-fs16
      `,
      footerCta: `
        ${this.BLOCK_CLASS}__footer-cta
        u-button -button-white u-fwn
      `,
      footerHeadline: `u-mt8 u-fs16 u-fwn u-ttu u-ls2`,
    }
  },

  classesWillUpdate: function () {
    return {
      footer: {
        'u-mt24': this.state.filterByEyeExamAvailability
      },
      hr: {
        '--dashed': this.state.filterByEyeExamAvailability
      }
    }
  },

  getBannerImages: function (sources) {
    if (!_.isArray(sources)) return [];

    const sortedSources = _.sortBy(sources, 'min_viewport_width').reverse();

    return sortedSources.map((src) => {
      return {
        url: src.url,
        mediaQuery: `(min-width: ${src.min_viewport_width}px)`,
        sizes: `${src.relative_image_width}vw`,
        widths:
          _.range(
            parseInt(src.min_image_width),
            parseInt(src.max_image_width) + 1,
            200
          )
      };
    });
  },

  sortLocations: function (locs) {
    // Map the flat array of locations into a country-keyed object containing
    // arrays of locations grouped and ordered by state/region name.

    const locsRegionGroup = _.values(_.groupBy(locs, 'address.region_name'))
    const locsRegionSort = _.sortBy(locsRegionGroup, '[0].address.region_name')
    const locsCitySort = _.map(locsRegionSort, (l) => _.sortBy(l, 'address.locality'))

    return _.groupBy(locsCitySort, '[0].address.country_code')
  },

  renderEyeExamToggle: function () {
    const {title, label, info} = _.get(this.props, 'content.eye_exam_toggle')

    return (
      <div className={this.classes.eyeExamToggle} key={'eye-exam-toggle'}>
        {title &&
          <p className={this.classes.eyeExamTitle}>{title}</p>}
        <Checkbox
          id={'locations-filter-eye-exam'}
          cssModifier={title ? '' : 'u-mt12'}
          cssModifierBox={'-border-light-gray'}
          cssModifierInput={'-align-middle'}
          txtLabel={label}
          isToggle={true}
          defaultChecked={this.state.filterByEyeExamAvailability}
          checked={this.state.filterByEyeExamAvailability}
          onClick={this.handleEyeExamToggle}
        />

        {this.state.filterByEyeExamAvailability &&
          <p className={this.classes.eyeExamInfo} children={info} />}
      </div>
    );
  },

  renderCountry: function (locations, country, i) {
    const headline = (function(country){
      switch (country) {
        case 'US':
          return 'Retail locations in the U.S.';
        default:
          return 'Retail locations in Canada';
      };
    }(country));

    return (
      locations[country]
        ?
          <section key={country} className={this.classes.countryGroup}>
            <h2 className={this.getHeaderClass(i)}
              children={headline} />
            {i === 0 && _.get(this.props, 'locationsEyeExam.length') && this.renderEyeExamToggle()}
            <section className={this.classes.regionGroup}
              children={_.map(locations[country], this.renderRegion)} />
          </section>
        : null
    );
  },

  getHeaderClass: function (i) {
    // check to see if the section being rendered is the first,
    // because the first section does not have a border-top

    if(i === 0) {
      return this.classes.countryNameFirst
    } else {
      return this.classes.countryName
    }
  },

  renderRegion: function (regionLocations, i) {
    return (
      <div key={i} className={this.classes.locationGroup}>
        <h3 className={this.classes.regionName}
          children={_.get(regionLocations, '[0].address.region_name')} />

        {_.map(regionLocations, this.renderLocation)}
      </div>
    );
  },

  getPriceRange: function (cmsContent) {
    let priceRange = _.get(cmsContent, 'priceRange', 0)
    if (priceRange === 0) {
      priceRange = (parseInt(this.getFeature("basePriceCents"), 10) / 100).toFixed()
    }

    return priceRange
  },

  renderLocation: function (loc, i) {
    const address = _.get(loc, 'address', {})
    const cmsContent = _.get(loc, 'cms_content')

    const locName =
      cmsContent
        ?
          <a children={cmsContent.name}
            href={`/retail/${loc.city_slug}/${loc.location_slug}`} />
        :
          <span children={cmsContent.name} />

    return (
      <div key={i}>
        <p className={this.classes.locationDetail}>
          <span className={this.classes.cityName}
            children={[address.locality, ', ', locName]} />
          <br />
          <span className={this.classes.address} children={address.street_address} />
          <br />
          <span className={this.classes.address} children={cmsContent.neighborhood} />

          {
            _.get(loc, 'offers_eye_exams', false) && this.inExperiment('eyeExamToggleRetail', 'enabled') &&
              <a
                onClick={this.clickInteraction.bind(this, 'book-eye-exam')}
                className='u-db'
                href={`/appointments/eye-exams/${loc.city_slug}/${loc.location_slug}`}
                children={"Book an eye exam"}
              />
          }
        </p>

        <LocalBusinessSchema
          name={cmsContent.name}
          telephone={cmsContent.phone}
          image={_.get(cmsContent, 'hero_image[0]', []).image}
          description={cmsContent.description}
          priceRange={this.getPriceRange(cmsContent)}
          url={`/appointments/eye-exams/${loc.city_slug}/${loc.location_slug}`}
          openingHours={_.get(loc, 'schedules', {})}
          hasMap={_.get(cmsContent, 'map_details', {}).url}
          geo={{
            latitude: _.get(cmsContent, 'map_details', {}).latitude,
            longitude: _.get(cmsContent, 'map_details', {}).longitude
          }}
          address={{
            streetAddress: (address.extended_address ? address.street_address + ', ' + address.extended_address : address.street_address),
            addressLocality: address.locality,
            addressRegion: address.region_code,
            postalCode: address.postal_code,
            addressCountry: address.country_code
          }} />

      </div>

    );
  },

  renderFooter: function (footer, eyeExamFooter) {
    const {heading, body, button_link, button_text} = footer
    const {image = {}, headline, info} = eyeExamFooter

    return (
      <div>

        {
          footer && !this.state.filterByEyeExamAvailability &&
            <div className={this.classes.footer}>
              <h4 className={this.classes.footerTitle} children={heading} />
              <p className={this.classes.footerDesc} children={body} />
              <CTA
                cssModifier={this.classes.footerCta}
                href={button_link}
                tagName={'a'}
                children={button_text}
              />
            </div>
        }

        {
          eyeExamFooter && this.state.filterByEyeExamAvailability &&
            <div className={this.classes.eyeExamFooter}>

              {
                !_.isEmpty(image.svg) &&
                  <svg className={this.classes.footerImage}
                    viewBox={image.svg.view_box}
                    {...image.svg}>
                    <title children={image.alt} />
                    <g children={image.svg.paths.map((path, i) => <path key={i} d={path} />)} />
                  </svg>
              }

              {
                _.isEmpty(image.svg) && image.url &&
                  <img className={this.classes.footerImage}
                    src={image.url}
                    alt={image.alt}
                  />
              }

              <h3 className={this.classes.footerHeadline} children={headline} />
              <p className={this.classes.footerDesc} children={info} />
            </div>
        }

        </div>
      );
    },

  handleEyeExamToggle: function () {
    return this.setState({filterByEyeExamAvailability: !this.state.filterByEyeExamAvailability}, () => {
      this.clickInteraction(`toggle-eye-exam-${this.state.filterByEyeExamAvailability ? 'on' : 'off'}`)
    });
  },

  render: function () {
    const {locations, locationsEyeExam, content} = this.props
    if (!locations && content) return false;

    const locationsSorted = this.state.filterByEyeExamAvailability ? this.sortLocations(locationsEyeExam) : this.sortLocations(locations);

    this.classes = this.getClasses();

    return (
      <div className={this.classes.block}>
        <Breadcrumbs
          links={this.props.breadcrumbs}
          cssModifier={'-over-hero'} />
        <HeroShort
          sources={this.getBannerImages(_.get(content, 'hero.sources', {}))} />

        {_.map(content.country_order, this.renderCountry.bind(this, locationsSorted))}

        <hr className={this.classes.hr} />

        {this.renderFooter(content.footer, content.eye_exam_footer)}
      </div>
    );
  }
});
