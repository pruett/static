import React, { Component } from "react";
import { hot } from "react-hot-loader";

class Main extends Component {
  render() {
    return (
      <div>
        <input type="text" />
        <h2>does this work?</h2>
        <h3>on node son</h3>
      </div>
    );
  }
}

export default hot(module)(Main);
