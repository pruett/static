const React = require("react/addons");
const _ = require("lodash");
const UnsupportedBrowserNotice = require("components/atoms/unsupported_browser_notice/unsupported_browser_notice");
const AppointmentContainer = require("components/organisms/appointments/appointment/container/container");
const AppointmentSuccess = require("components/organisms/appointments/appointment/success/success");
const CTA = require("components/atoms/buttons/cta/cta");
const Markdown = require("components/molecules/markdown/markdown");
const Img = require("components/atoms/images/img/img");
const Slider = require("components/organisms/carousel/adaptive/adaptive");
const LocationsStructuredMarkup = require("components/molecules/locations/structured_markup/structured_markup");
const Urls = require("components/utilities/urls");
const Mixins = require("components/mixins/mixins");
const Styles = require("./style/style")("c-location-v2");

require("./location.scss");

module.exports = React.createClass({
  ANALYTICS_CATEGORY: "RetailDetail",

  mixins: [
    Mixins.analytics,
    Mixins.dispatcher,
    Mixins.image,
    Mixins.conversion
  ],

  propTypes: {
    location: React.PropTypes.object,
    eyeExams: React.PropTypes.oneOfType([
      React.PropTypes.shape({
        data: React.PropTypes.object,
        content: React.PropTypes.object
      }),
      React.PropTypes.bool
    ])
  },

  componentWillMount() {
    this.requestDispatcher("appointments", "set", { redirectOnSave: false });
    this.requestDispatcher("appointments", "clearConfirmation");
  },

  getInitialState() {
    return {
      showAppointmentPicker: false
    };
  },

  renderAddress(address, phone, mapDetails, Styles) {
    return (
      <div>
        <div className={Styles.Intro.address}>
          <a
            onClick={this.clickInteraction.bind(this, "address")}
            href={mapDetails.url ? mapDetails.url : ""}
          >
            <span>{address.street_address}</span>
            {address.extended_address && (
              <span>{address.extended_address}</span>
            )}
            <span
            >{`${address.locality}, ${address.region_code} ${address.postal_code}`}</span>
          </a>
        </div>

        {phone && (
          <div className={Styles.Intro.phoneNumber}>
            <a
              className={"u-color--dark-gray-alt-3"}
              href={`tel:+1-${_.kebabCase(phone)}`}
              onClick={this.clickInteraction.bind(this, "phoneNumber")}
              children={phone}
            />
          </div>
        )}
      </div>
    );
  },

  renderSchedule(schedule) {
    return _.map(schedule, (x, i) => {
      if (x.closed) return null;
      return (
        <div key={i} className={Styles.Intro.hoursBlock}>
          <p className={Styles.Intro.upperTitle}>
            {x.days.length > 1
              ? `${_.head(x.days)}\u2013${x.days.slice(-1)}`
              : _.head(x.days)}
          </p>
          <p className={Styles.Intro.hours}>{`${x.hours.open}\u2013${x.hours
            .close}`}</p>
        </div>
      );
    });
  },

  renderServices(services, Styles) {
    return (
      <section className={Styles.Services.section}>
        <div className={Styles.Services.grid}>
          <div className={Styles.Services.row}>
            <div className={Styles.Services.col}>
              <h1 className={Styles.Services.heading}>Swing by for...</h1>
              <div
                className={Styles.Services.container(services.length % 3 === 0)}
              >
                {_.map(
                  services,
                  this.renderServicesCallout.bind(this, Styles, services.length)
                )}
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  },

  renderServicesCallout(Styles, numServices, service, i) {
    const props = _.find(this.props.services, { slug: service });
    const widths = [220, 275, 330, 385, 440];

    return (
      props && (
        <div className={Styles.Services.callout(numServices % 3 === 0)} key={i}>
          <Img
            cssModifier={Styles.Services.image}
            srcSet={this.getSrcSet({ url: props.image, widths })}
          />
          <h2 className={Styles.Services.name}>{props.heading}</h2>
          <p className={Styles.Services.description}>{props.body}</p>
        </div>
      )
    );
  },

  formatHours(acc, day) {
    // Merge days with the same open/close hours into
    // one array for cleaner presentation, e.g. "Mon-Thu 10-6".

    let hours = _.get(this.props, `location.schedules[0].hours.${day}`);
    let dayCount = acc.length;
    let prevSched = dayCount > 0 ? acc[dayCount - 1] : null;

    if (!(hours && hours.open && hours.close)) {
      // No hours available for this day.

      if (prevSched && prevSched.closed) {
        // If the previous day was closed, add current day to previous day's.
        acc[dayCount - 1].days.push(day);
      } else {
        // Start a new array for closed days.
        acc.push({ closed: true, days: [day] });
      }

      return acc;
    }

    let openTime = this.formatTime(hours.open);
    let closeTime = this.formatTime(hours.close);

    if (
      prevSched &&
      prevSched.hours &&
      prevSched.hours.open === openTime &&
      prevSched.hours.close === closeTime
    ) {
      // Current day's hours match the previous day's, so add current day to
      // previous day's array.
      acc[dayCount - 1].days.push(day);
    } else {
      // Current day is the first in the list, or its hours don't match the
      // previous day's, so add a new object.
      acc.push({
        hours: {
          open: openTime,
          close: closeTime
        },
        days: [day]
      });
    }

    return acc;
  },

  formatTime(time) {
    if (time.indexOf(":00") > 0) {
      return time
        .split(":00")
        .join("")
        .toLowerCase();
    } else {
      return time.toLowerCase();
    }
  },

  bookAppointment() {
    this.setState({ showAppointmentPicker: true });
  },

  handleClickChange(evt) {
    evt.preventDefault();
    this.commandDispatcher("appointments", "change");
    this.trackInteraction("appointments-change-appointment", evt);
  },

  eyeExamPriceByLocation(location = "") {
    switch (location.short_name) {
      case "RNBY":
        return "$105";
      default:
        return "$75";
    }
  },

  renderSlider(cmsContent) {
    const { slides, grouping } = cmsContent;

    return <Slider slides={slides} grouping={grouping} />;
  },

  renderIntro(Styles, renderArgs = {}) {
    const { location, cmsContent } = renderArgs;
    const days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
    const schedule = days.reduce(this.formatHours, []);

    return (
      <section className={Styles.Intro.section}>
        <div className={Styles.Intro.grid}>
          <div className={Styles.Intro.row}>
            <div className={Styles.Intro.col}>
              <h1 className={Styles.Intro.storeName}>
                {cmsContent.name || location.name}
              </h1>
              {location.address &&
                this.renderAddress(
                  location.address,
                  cmsContent.phone,
                  cmsContent.map_details,
                  Styles
                )}

              {cmsContent.description && (
                <p className={Styles.Intro.locationDescription}>
                  {cmsContent.description}
                </p>
              )}

              {location.schedules && (
                <div
                  className={`${Styles.Intro.hoursContainer} ${schedule.length >
                  3
                    ? "u-flexw--w"
                    : ""}`}
                >
                  {this.renderSchedule(schedule)}
                </div>
              )}

              {cmsContent.hours_note && (
                <div className="u-btss u-btw1 u-bc--light-gray-alt-1 u-mt24 u-pt24">
                  <h3 className={Styles.Intro.upperTitle}>Notes</h3>
                  <p className={Styles.Intro.hoursNote}>
                    {cmsContent.hours_note}
                  </p>
                </div>
              )}
            </div>
          </div>
        </div>
      </section>
    );
  },
  renderAppointmentFooter(appointment) {
    switch (appointment.booking_status) {
      case "inProgress":
        const dateObj = this.convert(
          "utcdate",
          "object",
          `${appointment.date.timestamp}Z`
        );

        return (
          <div
            className={Styles.Appointment.footerActionContainer}
            key={"date-time"}
          >
            <p
              className={Styles.Appointment.footerDateTime}
            >{`${dateObj.month} ${dateObj.date} at ${dateObj.formattedTime}`}</p>
            <a
              className={Styles.Appointment.footerAction}
              onClick={this.handleClickChange}
            >
              Choose a different day or time
            </a>
          </div>
        );
      case "complete":
        return (
          <div
            className={Styles.Appointment.footerActionContainer}
            key={"book-another"}
          >
            <a className={Styles.Appointment.footerAction}>
              Book another appointment
            </a>
          </div>
        );
    }
  },

  renderAppointmentCallout(Styles, renderArgs = {}) {
    const {
      showAppointmentPicker,
      appointments,
      location,
      session
    } = renderArgs;

    return (
      <section
        ref={node => (this.appointmentContainerRef = node)}
        className={Styles.Appointment.section}
      >
        <div className={Styles.Appointment.welcome(showAppointmentPicker)}>
          <div className={Styles.Appointment.grid}>
            <div className={Styles.Appointment.row}>
              <div className={Styles.Appointment.col}>
                <h2 className={Styles.Appointment.welcomeHeader}>
                  Book an eye exam
                </h2>
                <p className={Styles.Appointment.welcomeDescription}>
                  {`The store offers comprehensive eye exams for ${this.eyeExamPriceByLocation(
                    location
                  )}. (You can pay
                  with an FSA or HSA card if you have one. If not, you can
                  always apply to be reimbursed through your insurance after
                  your exam. It's easy!)`}
                </p>
                <CTA
                  variation={"primary"}
                  cssModifier={"u-ffss u-fs16"}
                  analyticsSlug={"RetailDetail-click-bookAppointment"}
                  onClick={this.bookAppointment}
                >
                  Get started
                </CTA>
              </div>
            </div>
          </div>
        </div>

        {appointments.appointment.booking_status === "complete" ? (
          <div className={Styles.Appointment.picker(showAppointmentPicker)}>
            <div className={Styles.Appointment.grid}>
              <div className={Styles.Appointment.row}>
                <AppointmentSuccess
                  appointment={appointments.appointmentConfirmation}
                />
              </div>
            </div>
          </div>
        ) : (
          <div className={Styles.Appointment.picker(showAppointmentPicker)}>
            <UnsupportedBrowserNotice />
            <AppointmentContainer
              appointment={appointments.appointment}
              appointments={appointments.appointments}
              appointmentContainerRef={this.appointmentContainerRef}
              content={{ notice: false }}
              key="container"
              location={location}
              session={session}
            />
          </div>
        )}

        {this.renderAppointmentFooter(appointments.appointment)}
      </section>
    );
  },

  renderBeforeYouGo(Styles, renderArgs = {}) {
    const { cms } = renderArgs;

    return (
      <section className={Styles.GTK.section}>
        <div className={Styles.GTK.grid}>
          <div className={Styles.GTK.row}>
            <div className={Styles.GTK.col}>
              <h1 className={Styles.GTK.heading}>{cms.heading}</h1>
              <div className={Styles.GTK.contentContainer}>
                {cms.img && (
                  <Img
                    cssModifier={Styles.GTK.image}
                    srcSet={this.getSrcSet({
                      url: cms.img,
                      widths: [400, 600]
                    })}
                  />
                )}
                <div className={Styles.GTK.content(cms.img)}>
                  <h3 className={Styles.GTK.subHeading}>Drop in anytime</h3>
                  <p className={Styles.GTK.paragraph}>
                    No appointments necessary here. Just swing by to browse our
                    full collection and get styling help from our advisors.
                  </p>
                  <h3 className={Styles.GTK.subHeading}>What to bring</h3>
                  <p className={Styles.GTK.paragraph}>
                    You don't need anything but your eyeballs to peruse and try
                    on our frames. It might be useful to have...
                  </p>
                  <ul className={Styles.GTK.ul}>
                    <li className={Styles.GTK.li}>
                      your current prescription (if you want to buy prescription
                      frames)
                    </li>
                    <li className={Styles.GTK.li}>
                      an FSA or HSA card (if you have one and you want to pay
                      for prescription frames with it)
                    </li>
                  </ul>
                  <p className={Styles.GTK.paragraph}>
                    If you don't have your prescription handy, you can order
                    frames at a store and email your prescription to us later.
                  </p>
                  <h3 className={Styles.GTK.subHeading}>Get reimbursed</h3>
                  <p className={Styles.GTK.paragraph}>
                    We can provide you with a digital receipt that makes it
                    quick and easy to apply for reimbursement from your vision
                    insurance company. Get all the details{" "}
                    <a
                      href="/insurance"
                      onClick={this.trackInteraction.bind(
                        this,
                        `${this.ANALYTICS_CATEGORY}-click-insurance`
                      )}
                    >
                      here
                    </a>.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  },

  renderNearbyLocations(Styles, renderArgs = {}) {
    const { nearbyLocations } = renderArgs;

    const outputStatus = (status, schedule) => {
      const now = new Date();

      switch (status) {
        case "open":
          const day = now
            .toString()
            .slice(0, 3)
            .toLowerCase();
          return `Open now until ${this.formatTime(schedule.hours[day].close)}`;
        case "closed":
          return "Now closed";
      }
    };

    return (
      <section className={Styles.Nearby.section}>
        <div className={Styles.Nearby.grid}>
          <div className={Styles.Nearby.row}>
            <div className={Styles.Nearby.col}>
              <h1 className={Styles.Nearby.heading}>Other nearby locations</h1>
              <ul className={Styles.Nearby.locationContainer}>
                {nearbyLocations.map((x, i) => (
                  <li className={Styles.Nearby.card} key={i}>
                    <div className={Styles.Nearby.cardContentContainer}>
                      <Img
                        cssModifier={Styles.Nearby.cardImage}
                        srcSet={this.getSrcSet({
                          url: x.cms_content.card_photo,
                          widths: [400, 800]
                        })}
                      />
                      <div className={Styles.Nearby.cardAbout}>
                        <h3 className={Styles.Nearby.locationName}>
                          <a
                            onClick={this.clickInteraction.bind(
                              this,
                              `nearbyLocation__${x.name}`
                            )}
                            href={`/retail/${x.city_slug}/${x.location_slug}`}
                          >
                            {x.name}
                          </a>
                        </h3>
                        <p className={Styles.Nearby.hours}>
                          {outputStatus(
                            x.currentStatus,
                            _.find(x.schedules, { name: "Store" })
                          )}
                        </p>
                        {_.get(x, "offers_eye_exams") && (
                          <p className={Styles.Nearby.eyeExamAvailability}>
                            Eye exams available
                          </p>
                        )}
                      </div>
                    </div>
                  </li>
                ))}
              </ul>
              <div className="u-tac">
                <a
                  onClick={this.clickInteraction.bind(this, "allLocations")}
                  href={"/retail"}
                  className={Styles.Nearby.linkAll}
                >
                  Search all our stores and showrooms
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  },

  render() {
    const {
      location,
      services,
      version,
      nearbyLocations,
      appointments,
      session
    } = this.props;
    const { showAppointmentPicker } = this.state;

    if (!location || !services) return false;

    const cmsContent = location.cms_content;

    return (
      <div>
        {this.renderSlider(cmsContent.hero_carousel)}

        {this.renderIntro(Styles, { location, cmsContent })}

        {appointments && appointments.__fetched ? (
          this.renderAppointmentCallout(Styles, {
            showAppointmentPicker,
            appointments,
            location,
            session
          })
        ) : (
          <div className={"u-btss u-btw1 u-bc--light-gray-alt-1"} />
        )}

        {!_.isEmpty(cmsContent.services) &&
          this.renderServices(cmsContent.services, Styles)}

        {!_.isEmpty(cmsContent.before_you_go) &&
          this.renderBeforeYouGo(Styles, { cms: cmsContent.before_you_go })}

        {!_.isEmpty(nearbyLocations) &&
          this.renderNearbyLocations(Styles, { nearbyLocations })}

        <LocationsStructuredMarkup
          location={location}
          cmsContent={cmsContent}
        />
      </div>
    );
  }
});
