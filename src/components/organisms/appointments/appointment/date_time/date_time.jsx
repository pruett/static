const _ = require("lodash");
const React = require("react/addons");
const AppointmentDate = require("components/atoms/appointment/date/date");
const AppointmentTimeSlots = require("components/molecules/appointment/time_slots/time_slots");
const Arrow = require("components/quanta/icons/down_arrow_thin/down_arrow_thin");
const Mixins = require("components/mixins/mixins");

require("./date_time.scss");

module.exports = React.createClass({
  BLOCK_CLASS: "c-appointment-date-time",

  SCROLL_DURATION: 300,
  SCROLL_EASING: "outQuad",

  mixins: [Mixins.analytics, Mixins.classes, Mixins.dispatcher, Mixins.easing],

  propTypes: {
    appointments: React.PropTypes.arrayOf(
      React.PropTypes.shape({
        date: React.PropTypes.string,
        day_of_week: React.PropTypes.string,
        pretty_date: React.PropTypes.string,
        slots: React.PropTypes.arrayOf(
          React.PropTypes.shape({
            pretty_full_time: React.PropTypes.string,
            pretty_time: React.PropTypes.string,
            timestamp: React.PropTypes.string
          })
        )
      })
    ),
    content: React.PropTypes.object,
    cssModifier: React.PropTypes.string,
    location: React.PropTypes.object,
    manageSetDate: React.PropTypes.func,
    manageSetTimeSlot: React.PropTypes.func
  },

  getDefaultProps() {
    return {
      appointments: [],
      content: {},
      cssModifier: ""
    };
  },

  getStaticClasses() {
    return {
      block: `${this.BLOCK_CLASS} ${this.props.cssModifier}`,
      headingImage: `${this
        .BLOCK_CLASS}__heading-image u-db u-mt0 u-mra u-mb24 u-mla`,
      heading: `${this
        .BLOCK_CLASS}__heading u-fs20 u-fs24--600 u-fs24--1200 u-tac u-ffs u-fws u-fsi`,
      headingHr: `${this
        .BLOCK_CLASS}__heading-hr u-mra u-mla u-mb24 u-bw0 u-bbw3 u-bc--blue`,
      fieldset: `${this.BLOCK_CLASS}__fieldset u-fieldset-reset`,
      legend: `${this
        .BLOCK_CLASS}__legend u-mb12 u-tac u-fs24 u-fs30--600 u-fs34--1200 u-ffs u-fws u-w100p`,
      dates: `${this.BLOCK_CLASS}__dates u-grid__row -center u-mb0`,
      scrollButtonColLeft: `${this
        .BLOCK_CLASS}__scroll-button-col u-grid__col u-w12c -c-1--900 -col-middle u-tal`,
      scrollButtonColRight: `${this
        .BLOCK_CLASS}__scroll-button-col u-grid__col u-w12c -c-1--900 -col-middle u-tar`,
      scrollButton: `${this.BLOCK_CLASS}__button u-button-reset`,
      arrowIcon: `${this.BLOCK_CLASS}__arrow u-stroke--dark-gray-alt-2`,
      datesCol: "u-grid__col u-w12c -c-10--900 -col-middle",
      scrollContainer: `${this
        .BLOCK_CLASS}__scroll-container u-mln6 u-ml0--900 u-mrn18 u-mrn36--600 u-mr0--900`,
      date: `${this.BLOCK_CLASS}__date u-dib`,
      month: `u-fs12 u-tac u-fws u-ttu u-color--dark-gray-alt-3 u-ls2_5 u-mb24`,
      welcome:
        "u-fs16 u-lh26 u-fs18--900 u-lh28--900 u-color--dark-gray-alt-3 u-w12c u-w6c--900 u-tac u-m0a u-mb42"
    };
  },

  handleScrollLeftClick(evt) {
    evt.preventDefault();

    this.scrollContainer("left");

    return this.trackInteraction("appointments-click-scrollLeft", evt);
  },

  handleScrollRightClick(evt) {
    evt.preventDefault();

    this.scrollContainer("right");

    return this.trackInteraction("appointments-click-scrollRight", evt);
  },

  scrollContainer(direction) {
    const el = this.refs["scroll-container"].getDOMNode();

    return this.setState(
      {
        scroll: {
          startTime: new Date().getTime(),
          startX: el.scrollLeft,
          distance: el.offsetWidth * (direction === "left" ? -1 : 1)
        }
      },
      this.updateScrollPosition.bind(this, el)
    );
  },

  updateScrollPosition(el) {
    const timeLeft = Math.min(
      1,
      (new Date().getTime() - this.state.scroll.startTime) /
        this.SCROLL_DURATION
    );

    el.scrollLeft =
      this.easingFunction[this.SCROLL_EASING](timeLeft) *
        this.state.scroll.distance +
      this.state.scroll.startX;

    if (timeLeft < 1) {
      return requestAnimationFrame(this.updateScrollPosition.bind(this, el));
    }
  },

  renderDate(appointment, i) {
    let isPast = false;
    let isToday = false;

    if (this.props.today) {
      const appointmentDate = new Date(appointment.date);
      appointmentDate.setUTCHours(0, 0, 0, 0);
      const appointmentTime = appointmentDate.getTime();

      isPast = this.props.today > appointmentTime;
      isToday = this.props.today === appointmentTime;
    }

    return (
      <AppointmentDate
        appointment={appointment}
        cssModifier={this.classes.date}
        isActive={appointment.date === this.props.activeDate}
        isPast={isPast}
        isToday={isToday}
        key={i}
        manageSetDate={this.props.manageSetDate}
      />
    );
  },

  renderTimeSlots(appointment, i) {
    return (
      <AppointmentTimeSlots
        active={appointment.date === this.props.activeDate}
        key={i}
        manageSetDate={this.props.manageSetDate}
        manageSetTimeSlot={this.props.manageSetTimeSlot}
        slots={appointment.slots}
        slotsBucketed={appointment.slots_bucketed}
        nextAvailable={appointment.next_available}
      />
    );
  },

  getMonths(acc, val) {
    return acc.indexOf(val.month) === -1 ? acc.concat(val.month) : acc;
  },

  eyeExamPriceByLocation(location = "") {
    switch (location.short_name) {
      case "RNBY":
        return "$105";
      default:
        return "$75";
    }
  },

  render() {
    this.classes = this.getClasses();

    return (
      <div className={this.classes.block}>
        <fieldset className={this.classes.fieldset}>
          <legend
            className={this.classes.legend}
            children="Pick a day and time"
          />
          <p
            className={this.classes.welcome}
          >{`Eye exams cost ${this.eyeExamPriceByLocation(
            this.props.location
          )} and take about 20 minutes`}</p>
          <p className={this.classes.month}>
            {this.props.appointments.reduce(this.getMonths, []).join("/")}
          </p>
          <div className={this.classes.dates}>
            <div className={this.classes.scrollButtonColLeft}>
              <button
                className={this.classes.scrollButton}
                onClick={this.handleScrollLeftClick}
                type="button"
              >
                <Arrow cssModifier={`${this.classes.arrowIcon} -left`} />
              </button>
            </div>
            <div className={this.classes.datesCol}>
              <div
                className={this.classes.scrollContainer}
                ref="scroll-container"
                children={this.props.appointments.map(this.renderDate)}
              />
            </div>
            <div className={this.classes.scrollButtonColRight}>
              <button
                className={this.classes.scrollButton}
                onClick={this.handleScrollRightClick}
                type="button"
              >
                <Arrow cssModifier={`${this.classes.arrowIcon} -right`} />
              </button>
            </div>
          </div>
          <div
            className={this.classes.timeSlots}
            children={this.props.appointments.map(this.renderTimeSlots)}
          />
        </fieldset>
      </div>
    );
  }
});
