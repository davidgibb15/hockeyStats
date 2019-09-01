import React from "react"
import PlayerHeadersRow from "./PlayerHeadersRow"
import PlayersStatsRow from "./PlayersStatsRow"

class PlayersStatsTable extends React.Component {
  state = { 
    data: this.props.players,
    lastSorted: null,
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
    if (this.state.data.length == 0) {
      return (
        <div>
          Please fill out form and click search
        </div>
      )
    } else {
      const values = this.props.categories.map(cat => cat.value)
      return(
        <table>
          <thead>
            <PlayerHeadersRow categories={this.props.categories} headerNames= {Object.keys(this.state.data[0])} onClickFunction={this.handleClick}/>
          </thead>
          <tbody>{this.state.data.map(player => <PlayersStatsRow key={player.player_id} {...player} categories={values} />)}</tbody>    
        </table>
      );
    }
  }
}

export default PlayersStatsTable