const React = require("react/addons");

/**
 *  React component to mount Elm.
 *  Prevents React from updating component.
 *
 *  Adapted from https://github.com/evancz/react-elm-components
 */

module.exports = React.createClass({
  displayName: "ReactElmComponent",

  propTypes: {
    ports: React.PropTypes.object,
    src: React.PropTypes.object,
    flags: React.PropTypes.object
  },

  componentDidMount: function() {
    const node = React.findDOMNode(this.refs["elm"]);
    if (node === null) return;
    var app = this.props.src.embed(node, this.props.flags);

    if (typeof this.props.ports !== "undefined") {
      this.props.ports(app.ports);
    }
  },

  shouldComponentUpdate: function() {
    return false;
  },

  render: function() {
    return <div ref="elm" />;
  }
});
