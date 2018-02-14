import React, { Component } from "react";
import { hot } from "react-hot-loader";

class Main extends Component {
  render() {
    console.log(this.props.initialData);
    const { github } = this.props.initialData;

    return github.message ? (
      <h1>You've been rate limited!!</h1>
    ) : (
      <div>
        <input type="text" />
        <h1>{`${github.login}'s Github!!???`}</h1>
        <h3>{github.name}</h3>
        <h4>{github.company || "NO COMPANY LISTED"}</h4>
        <img src={`${github.avatar_url}`} width={150} height={150} />
      </div>
    );
  }
}

export default hot(module)(Main);
