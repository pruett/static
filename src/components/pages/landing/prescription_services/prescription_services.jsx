const _ = require("lodash");
const React = require("react/addons");
const LayoutDefault = require("components/layouts/layout_default/layout_default");

const Hero = require("components/molecules/landing/prescription_how_to/hero/hero");

const Quiz = require("components/organisms/landing/prescription_services/quiz/quiz");
const Success = require("components/organisms/landing/prescription_services/success/success");
const Devices = require("components/organisms/landing/prescription_services/devices/devices");
const Copy = require("components/organisms/landing/prescription_services/copy/copy");

const Mixins = require("components/mixins/mixins");

const { RX_CHECK_REGIONS } = require("components/utilities/prescription_services/constants");
const STEPS = require("components/utilities/prescription_services/steps");

require("./prescription_services.scss");

const BLOCK_CLASS = "c-prescription-services";
const CLASSES = {
  block: `${BLOCK_CLASS} u-mw1440 u-ma u-oh u-ov--900`,
  main: "u-color-bg--light-gray-alt-5 u-pb36 u-pt36",
  quiz: `${BLOCK_CLASS}__quiz u-pt48 u-pb48 u-pt84--900 u-pb84--900 u-tac u-ma`,
  strong: "u-fws"
};

const ANALYTICS_SLUG = "prescriptionCheckStore";

const HERO_DATA = {
  hero: {
    header: "A new, ultra-quick way to update your prescription",
    description:
      "If you’re close to a participating location *and* eligible, our In-store Prescription Check service allows an eye doctor to assess your vision and provide an updated glasses prescription. You’ll be charged $40 if you receive a prescription.",
    image_desktop:
      "https://i.warbycdn.com/v/c/assets/prescription-services/image/hero/0/94ffb81d2b.jpg",
    image_tablet:
      "https://i.warbycdn.com/v/c/assets/prescription-services/image/hero/0/94ffb81d2b.jpg",
    image_mobile:
      "https://i.warbycdn.com/v/c/assets/prescription-services/image/hero/0/94ffb81d2b.jpg",
    video_text: "Watch a short video",
    video_url:
      "https://player.vimeo.com/external/234406942.hd.mp4?s=53af0669f09d04579980fb7fb383539e85bb60d3&profile_id=174"
  },
  popout: {
    header: " All the details",
    description: "Everything you need to know before you head in"
  }
};

const PrescriptionServices = React.createClass({
  displayName: _.camelCase(BLOCK_CLASS),

  ANALYTICS_CATEGORY: ANALYTICS_SLUG,

  mixins: [Mixins.analytics, Mixins.context, Mixins.dispatcher, Mixins.routing, Mixins.scrolling],

  statics: {
    route: function() {
      return {
        path: "/prescription-check-store",
        handler: "PrescriptionServices",
        title: "In-store Prescription Check"
      };
    }
  },

  getInitialState: function() {
    return {
      rxCheckStores: []
    };
  },

  receiveStoreChanges: function() {
    return ["fetch"];
  },

  componentWillMount: function() {
    // Overload zip code...
    STEPS.ZIP_CODE.next = zipCode => callback => {
      this.commandDispatcher("fetch", "fetch", "zipCode", `/api/v2/nearby_stores/${zipCode}`);
      this.callback = callback;
    };
  },

  getStoreChangeHandlers: function() {
    return {
      fetch: "handleFetch"
    };
  },

  handleClickJump: function(evt) {
    evt.preventDefault();
    this.clickInteraction("jump");
    this.scrollToNode(this.refs["survey"]);
  },

  handleFetch: function(store) {
    if (!store.zipCode) return;
    const { data, err } = store.zipCode;
    if (err) {
      this.callback(STEPS.REJECTION_NO_STORES);
    }

    const { nearby_stores = [], location } = data || {};
    const rxCheckStores = nearby_stores.filter(store => store.info.offers_rx_check);
    if (rxCheckStores.length) {
      this.setState({ rxCheckStores });
      this.callback(STEPS.AGE);
    } else if (location && RX_CHECK_REGIONS.indexOf(location.region_code) > -1) {
      this.callback(STEPS.REJECTION_DOWNLOAD_APP);
    } else if (nearby_stores.some(store => store.info.offers_eye_exams)) {
      this.callback(STEPS.REJECTION_GET_EYE_EXAM);
    } else {
      this.callback(STEPS.REJECTION_NO_STORES);
    }
  },

  render: function() {
    return (
      <LayoutDefault cssModifier={"-full-page"} {...this.props}>
        <div className={CLASSES.block}>
          <Hero
            cssModifierHeader="u-fs30 u-fs24--600 u-fs30--900 u-fs40--1200"
            cssModiferDescription="u-fs16 u-fs14--600 u-fs18--900"
            isVideoAvailable={true}
            analyticsSlug={ANALYTICS_SLUG}
            hero={HERO_DATA.hero}
            popout={HERO_DATA.popout}
          />
          <main className={CLASSES.main}>
            <Copy handleClickJump={this.handleClickJump} />
          </main>
          <section id="survey" ref="survey" className={CLASSES.quiz} style={{ minHeight: "480px" }}>
            <Quiz step={STEPS.START} clickInteraction={this.clickInteraction}>
              <Success rxCheckStores={this.state.rxCheckStores} />
            </Quiz>
          </section>
        </div>
      </LayoutDefault>
    );
  }
});

module.exports = PrescriptionServices;
