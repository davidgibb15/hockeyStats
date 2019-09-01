import React from "react"

class PlayersStatsRow extends React.Component {
  render() {
    return(
      <tr>{this.props.categories.map((cat) => <td key={cat}>{(isNaN(this.props[cat])) ? (this.props[cat]) : (Math.round(this.props[cat] * 100) / 100)}</td> )}</tr>
    );
  }
}
export default PlayersStatsRow