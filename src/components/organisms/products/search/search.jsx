const _ = require("lodash");
const React = require("react/addons");

const FrameSearch = require("components/molecules/products/global_search/global_search");
const Takeover = require("components/molecules/modals/takeover/takeover");

const Mixins = require("components/mixins/mixins");

module.exports = React.createClass({
  displayName: "Search",

  mixins: [Mixins.analytics, Mixins.context, Mixins.dispatcher],

  receiveStoreChanges: function() {
    return ["search"];
  },

  getInitialState: function() {
    return {
      keypressStart: false,
      query: ""
    };
  },

  getEscapeInteraction: function() {
    return [
      "globalSearch",
      "escape",
      "inputField",
      _.camelCase(this.state.query)
    ].join("-");
  },

  handleCloseSearch: function(evt) {
    if (evt) evt.preventDefault();

    this.commandDispatcher("search", "disable");
    this.setState({
      keypressStart: false,
      query: ""
    });
  },

  handleQueryChange: function(evt) {
    const value = evt.target.value;
    if (this.state.keypressStart && !value) {
      this.trackInteraction("globalSearch-deleteClose-inputField");
      this.handleCloseSearch();
    } else {
      this.setState({ query: value });
    }
  },

  render: function() {
    const search = this.getStore("search");
    return (
      <Takeover
        active={search.active}
        hasHeader={false}
        analyticsSlug="globalSearch-close-search"
      >
        <FrameSearch
          filters={search.filters}
          frames={search.frames}
          title={"WARBY PARKER"}
          query={this.state.query}
          manageChange={this.handleQueryChange}
          manageClose={this.handleCloseSearch}
        />
      </Takeover>
    );
  }
});
