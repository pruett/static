const _ = require("lodash");
const React = require("react/addons");

const FrameSearch = require("components/molecules/products/frame_search/frame_search");
const Takeover = require("components/molecules/modals/takeover/takeover");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  mixins: [
    Mixins.analytics,
    Mixins.dispatcher,
  ],

  getInitialState() {
    return {
      openFromKeypress: false,
      query: "",
    };
  },

  componentDidMount() {
    window.addEventListener("keyup", this.handleKeypress);
  },

  componentWillUnmount() {
    window.removeEventListener("keyup", this.handleKeypress);
  },

  shouldOpenOnKeyPress(code) {
    // Only open if typing alpha key and no other modal open.
    return (
      !this.props.active &&
      !this.props.favoritesLoginActive &&
      code >= 65 &&
      code <= 90 &&
      !this.props.globalSearchActive
    );
  },

  handleKeypress(evt) {
    const code = evt.which || evt.keyCode;
    if (this.shouldOpenOnKeyPress(code)) {
      evt.preventDefault();
      this.trackInteraction("search-typeOpen-inputField");
      this.setState({
        openFromKeypress: true,
        query: String.fromCharCode(code)
      },this.props.openSearch);
    }
    else if (this.props.active && code === 27) {
      // ESC key pressed, close modal.
      this.trackInteraction(
        [
          "searchModal",
          "escape",
          "inputField",
          this.state.query.toLowerCase()
        ].join("-")
      );
      this.handleCloseSearch();
    }
  },

  handleCloseSearch(evt) {
    if (evt) {
      evt.preventDefault();
    }
    this.commandDispatcher("layout", "hideTakeover");
    this.props.closeSearch();
    this.setState({
      openFromKeypress: false,
      query: ""
    });
  },

  handleQueryChange(evt) {
    if (this.state.openFromKeypress && evt.target.value === "") {
      this.trackInteraction("searchModal-deleteClose-inputField");
      this.handleCloseSearch();
    }
    else {
      this.setState({ query: evt.target.value });
    }
  },

  render() {
    return (
      <Takeover
        active={this.props.active && !this.props.globalSearchActive}
        cssModifier={`u-color-bg--white${this.state.query.length ? "" : "-95p"}`}
        hasHeader={false}>

        <FrameSearch
          filters={this.props.filters}
          frames={this.props.frames}
          htoMode={this.props.htoMode}
          manageChange={this.handleQueryChange}
          manageClose={this.handleCloseSearch}
          query={this.state.query}
          title={this.props.title} />

      </Takeover>
    );
  }
});
