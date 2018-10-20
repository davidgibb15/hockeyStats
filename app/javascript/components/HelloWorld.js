import React from "react"
import Child from "./Child.js"
import SearchForm from "./SearchForm"
import PlayersStatsTable from "./PlayersStatsTable.js"
class HelloWorld extends React.Component {
  render () {
    return (
      <div className="reactco">
      	<SearchForm stats={PLAYERS_STATS}/>
        Greeting: {this.props.greeting}
      </div>
    );
  }
}
const PLAYERS_STATS = [
  {name: 'charlie', goals: '2', assists: '5', id: 1},
  {name: 'eleri', goals: '5', assists: '4', id: 2},
  {name: 'david', goals: '4', assists: '2', id: 3}
];
export default HelloWorld
