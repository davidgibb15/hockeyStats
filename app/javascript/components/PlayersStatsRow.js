import React from "react"

class PlayersStatsRow extends React.Component {
  render() {
    return(
      <tr>
        {this.props.categories.map(
          (cat) => 
            <td key={cat}>
              {this.props[cat]}
            </td> 
        )}
      </tr>
    );
  }
}
export default PlayersStatsRow