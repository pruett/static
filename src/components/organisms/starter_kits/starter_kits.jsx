const React = require('react/addons');

const Kits = require('components/organisms/starter_kits/kits/kits');
const Selector = require('components/organisms/starter_kits/selector/selector');

const Mixins = require('components/mixins/mixins');

module.exports = React.createClass({

  ANALYTICS_CATEGORY: 'htoStarterKit',

  mixins: [
    Mixins.analytics,
    Mixins.scrolling
  ],

  getDefaultProps: function() {
    return {
      favorites: [],
      kits: [],
      session: {},
      settings: {},
      showFavorites: false,
      timesKitGroupsHaveShown: 0
    };
  },

  getInitialState: function() {
    return {
      headerIsSticky: false
    };
  },

  componentDidMount: function() {
    this.checkStickyHeader();
    this.addScrollListener(this.checkStickyHeader);
  },

  checkStickyHeader: function() {
    // If we're within the kits (but past the promo block), enable the sticky header
    const kits = React.findDOMNode(this.refs.kits);
    if(kits) {
      const rect = kits.getBoundingClientRect();
      this.setState({headerIsSticky: rect ? rect.top <= 0 && rect.bottom >= 0 : false});
    }
  },

  scrollToPromo: function(evt) {
    evt.preventDefault();
    this.scrollToNode(React.findDOMNode(this.refs.promo), {rate: 5});
    this.trackInteraction(`${this.ANALYTICS_CATEGORY}-click-edit`);
  },

  render: function() {
    return(
      <div>
        <Selector ref={'promo'}
          analyticsCategory={this.ANALYTICS_CATEGORY}
          scrollToPromo={this.scrollToPromo}
          settings={this.props.settings}
          stickyHeader={this.state.headerIsSticky} />

        <Kits ref={'kits'}
          analyticsCategory={this.ANALYTICS_CATEGORY}
          favorites={this.props.favorites}
          showFavorites={this.props.showFavorites}
          timesKitGroupsHaveShown={this.props.timesKitGroupsHaveShown}
          kits={this.props.kits}
          session={this.props.session} />
      </div>
    );
  }

});
