import React from "react"
import PlayerHeadersRow from "./PlayerHeadersRow"
import PlayersStatsRow from "./PlayersStatsRow"

class PlayersStatsTable extends React.Component {
  state = { 
    data: this.props.players,
    lastSorted: null
  }
  componentWillReceiveProps(nextProps){
    if(nextProps.players!== this.props.players){
      this.setState({data: nextProps.players});
    }
  }
  handleClick = (columnName) => {
    if (columnName === this.state.lastSorted) {
      this.setState((prevState) => ({
        data: prevState.data.reverse()
      })); 
    } else{
      this.setState((prevState) => ({
        data: prevState.data.sort(function(player1, player2){
          return player1[columnName] - player2[columnName];
        }),
        lastSorted: columnName
      }));  
    }
  }
  
  render() {
    return(
      <table>
        <thead>
          <PlayerHeadersRow headerNames= {Object.keys(this.state.data[0])} onClickFunction={this.handleClick}/>
        </thead>
        <tbody>{this.state.data.map(player => <PlayersStatsRow key={player.name} {...player} />)}</tbody>    
      </table>
    );
  }
}

export default PlayersStatsTable