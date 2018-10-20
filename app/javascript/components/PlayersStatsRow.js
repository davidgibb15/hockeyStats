import React from "react"

class PlayersStatsRow extends React.Component {
  render() {
    return(
      <tr>{Object.values(this.props).map((a, index) => <td key={index}>{a}</td> )}</tr>
    );
  }
}
export default PlayersStatsRow