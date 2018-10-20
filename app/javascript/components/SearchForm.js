import React from "react"
import Filters from "./Filters"
import StatSelect from "./StatsSelect"
import PlayersStatsTable from "./PlayersStatsTable"
class SearchForm extends React.Component {
  state = {
    filterValue: '',
    droppedDown: false,
    ageRange: [18,50],
    yearsInLeague: [0, 25],
    positions: {
      c: true,
      rw: true,
      lw: true,
      d: true,
    },
    filteredUnselectedObjects: [],
    unselectedObjects: [],
    selectedObjects: [],
    players_stats: this.props.stats,
    positions:[
      {name: 'C', checked: true},
      {name: 'LW', checked: true},
      {name: 'RW', checked: true},
      {name: 'D', checked: true}
    ],
    categories: [
      {value: 'goalsCB', text: 'Goals', weight: 1, checked: true},
      {value: 'assistsCB', text: 'Assists', weight: 1, checked: true},
      {value: 'PointsCB', text: 'Points', weight: 1, checked: false},
      {value: 'SHGCB', text: 'SHGs', weight: 1, checked: false},
      {value: 'SHACB', text: 'SHAs', weight: 1, checked: false},
      {value: 'SHPCB', text: 'SHPs', weight: 1, checked: false},
      {value: 'PPGCB', text: 'PPGs', weight: 1, checked: false},
      {value: 'PPACB', text: 'PPAs', weight: 1, checked: false},
      {value: 'PPPCB', text: 'PPPs', weight: 1, checked: true},
      {value: 'GWGCB', text: 'GWGs', weight: 1, checked: true},
      {value: 'HitsCB', text: 'Hits', weight: 1, checked: true},
      {value: 'PIMCB', text: 'PIMs', weight: 1, checked: true},
      {value: 'BlocksCB', text: 'Blocks', weight: 1, checked: true},
      {value: 'TakeawaysCB', text: 'Tkwys', weight: 1, checked: false},
      {value: 'ShotsCB', text: 'Shots', weight: 1, checked: true},
      {value: 'TOICB', text: 'TOI', weight: 1, checked: false},
      {value: 'FOWCB', text: 'FOW', weight: 1, checked: false},
      {value: 'FOLCB', text: 'FOL', weight: 1, checked: false},
      {value: 'FOPCB', text: 'FO%', weight: 1, checked: false},
      {value: 'PlusMinusCB', text: '+-', weight: 1, checked: false},
      {value: 'GiveawaysCB', text: 'Gvwys', weight: 1, checked: false},
    ]
  }
  componentDidMount(){
    console.log('hi')
    fetch('api/v1/players/index')
      .then((response) => {return response.json()})
      .then((data) => {this.setState( {filteredUnselectedObjects: data, unselectedObjects: data })});

    fetch('api/v1/search/search')
      .then((response) => {return response.json()})
      .then((data) => {this.setState( {players_stats: data})});
  }
  handleDropDownClick = () => {
    this.setState((prevState) => ({
      droppedDown: !prevState.droppedDown
    }));
  }
  handleSearch = () => {
    fetch('api/v1/search/search')
      .then((response) => {return response.json()})
      .then((data) => {this.setState({players_stats: data})})
  }
  filterList = (event) => {
    var updatedList = this.state.unselectedObjects;
    updatedList = updatedList.filter(function(item){
      return item.name.toLowerCase().search(
      event.target.value.toLowerCase()) !== -1;
    });
    this.setState({
      filteredUnselectedObjects: updatedList,
      filterValue: event.target.value
    })
  }
  handleSelect = (index) => {
    var obj = this.state.filteredUnselectedObjects[index]
    var newSelected = this.state.selectedObjects.slice()
    newSelected.push(obj)
    
    var newUnselected = this.state.unselectedObjects.slice()
    var originalIndex = newUnselected.indexOf(obj);
    newUnselected.splice(originalIndex, 1)
    
    var newFilteredUnselected = this.state.filteredUnselectedObjects.slice()
    newFilteredUnselected.splice(index, 1)
  
    this.setState({
      selectedObjects: newSelected,
      unselectedObjects: newUnselected,
      filteredUnselectedObjects: newFilteredUnselected
    });
  }
  
  handleUnselect = (index) => {
    var obj = this.state.selectedObjects[index]
    var newUnselected = this.state.unselectedObjects.slice()
    newUnselected.push(obj)
    var newFilteredUnselected = this.state.filteredUnselectedObjects.slice()
    if(obj.name.toLowerCase().search(this.state.filterValue.toLowerCase()) !== -1)
    {
      newFilteredUnselected.push(obj)
    }
    var newSelected = this.state.selectedObjects.slice()
    newSelected.splice(index, 1)
    this.setState({
      unselectedObjects: newUnselected,
      selectedObjects: newSelected,
      filteredUnselectedObjects: newFilteredUnselected
    });
  }
  
  handleStatCheck = (index) => {
    var categoryInputNew = this.state.categories[index]
    categoryInputNew.checked = !categoryInputNew.checked
    
    var categoriesNew = this.state.categories
    categoriesNew[index]=categoryInputNew
    
    this.setState(() => ({
      categories: categoriesNew
    }));
  }
  handleStatWeightChange = (event, index) => {
    var categoryInputNew = this.state.categories[index]
    categoryInputNew.weight = event.target.value
    
    var categoriesNew = this.state.categories
    categoriesNew[index]=categoryInputNew
    this.setState({ categories: categoriesNew }); 
  }
  handlePositionChange = (event, index) => {
    var positionNew = this.state.positions[index]
    positionNew.checked = !positionNew.checked
    var positionsNew = this.state.positions 
    positionsNew[index]=positionNew
    this.setState({ positions: positionsNew }); 
  }
  handleRangeChange= (event, index, stateName) => {
    var rangesNew = this.state[stateName]
    rangesNew[index]= event.target.value
    this.setState({ [stateName]: rangesNew }); 
  }
  array_chunk= (arr, size) => {
    var result = [];
    for (var i = 0; i < arr.length; i += size) {
      result.push(arr.slice(i, size + i));
    }
    return result;
  };
  render() {
    const columnLength = 3
    const rows = this.array_chunk(this.state.categories, columnLength)
     
    return (
      <div>
      <form className="searchForm">
        <div className="stat-select">
          {rows.map((row, i) => (
            <span key={i} className="statColumn">
             {
              row.map((col, j) => (
                <StatSelect 
                  index={i*columnLength + j}
                  key={col.text}
                  checked={col.checked}
                  weight={col.weight}
                  name={col.text}
                  onCheckChange={this.handleStatCheck}
                  onWeightChange={this.handleStatWeightChange}
                 />
              ))
             }
             </span>
            ))
          } 
        </div>
        <div className={this.state.droppedDown ? 'visible' : 'invisible'}>
          <Filters
            handleUnselect = {this.handleUnselect}
            handleSelect = {this.handleSelect}
            filterList = {this.filterList}
            unselectedObjects = {this.state.filteredUnselectedObjects}
            selectedObjects = {this.state.selectedObjects}
            filterValue = {this.state.filterValue}
            positions = {this.state.positions}
            handlePositionChange = {this.handlePositionChange}
            ageRange = {this.state.ageRange}
            handleRangeChange = {this.handleRangeChange}
            yearsInLeague = {this.state.yearsInLeague}
          />
        </div>
        <div>
        <button 
          type='button'
          onClick = {this.handleDropDownClick}
          className="dropdown">
          Filters <i className={this.state.droppedDown ? 'arrow up' : 'arrow down'}></i>
        </button></div>
      </form>
      <PlayersStatsTable players={this.state.players_stats}/>
      </div>
    );
  }
}

const PLAYERS_STATS2 = [
  {name: 'charlie2', goals2: '4', assists2: '5', id: 324},
  {name: 'eleri2', goals2: '324', assists2: '4', id: 223},
  {name: 'david2', goals2: '243', assists2: '2', id: 3423}
];
const PLAYERS = [
  {name: 'charlie', goals: '2', assists: '5', id: 1},
  {name: 'eleri', goals: '5', assists: '4', id: 2},
  {name: 'david', goals: '4', assists: '2', id: 3}
];

export default SearchForm