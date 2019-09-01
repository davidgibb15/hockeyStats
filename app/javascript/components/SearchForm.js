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
    minGames: 5,
    filteredUnselectedObjects: [],
    filteredSelectedObjects: [],
    unselectedObjects: [],
    selectedObjects: [],
    players_stats: [],
    positions:[
      {name: 'C', checked: true},
      {name: 'LW', checked: true},
      {name: 'RW', checked: true},
      {name: 'D', checked: true}
    ],
    displayed_categories: [
      {text: 'Name', value: 'name'},
      {text: 'Goals', value: 'goals'},
      {text: 'Assists', value: 'assists'},
      {text: 'Shots', value: 'shots'},
      {text: 'Blocks', value: 'blocks'},
      {text: 'Hits', value: 'hits'},
      {text: 'PIM', value: 'pim'},
      {text: 'PPP', value: 'ppp'},
      {text: 'GWG', value: 'gwg'},
      {text: '+-', value: 'plus_minus'},
      {text: 'Rating', value: 'score'}
    ],
    categories: [
      {value: 'goals', text: 'Goals', weight: 1, checked: true},
      {value: 'assists', text: 'Assists', weight: 1, checked: true},
      {value: 'Points', text: 'Points', weight: 1, checked: false},
      {value: 'shg', text: 'SHGs', weight: 1, checked: false},
      {value: 'sha', text: 'SHAs', weight: 1, checked: false},
      {value: 'shp', text: 'SHPs', weight: 1, checked: false},
      {value: 'ppg', text: 'PPGs', weight: 1, checked: false},
      {value: 'ppa', text: 'PPAs', weight: 1, checked: false},
      {value: 'ppp', text: 'PPPs', weight: 1, checked: true},
      {value: 'gwg', text: 'GWGs', weight: 1, checked: true},
      {value: 'hits', text: 'Hits', weight: 1, checked: true},
      {value: 'pim', text: 'PIMs', weight: 1, checked: true},
      {value: 'blocks', text: 'Blocks', weight: 1, checked: true},
      {value: 'tka', text: 'Tkwys', weight: 1, checked: false},
      {value: 'shots', text: 'Shots', weight: 1, checked: true},
      {value: 'toi', text: 'TOI', weight: 1, checked: false},
      {value: 'fow', text: 'FOW', weight: 1, checked: false},
      {value: 'fol', text: 'FOL', weight: 1, checked: false},
      {value: 'FOPC', text: 'FO%', weight: 1, checked: false},
      {value: 'plus_minus', text: '+-', weight: 1, checked: false},
      {value: 'gva', text: 'Gvwys', weight: 1, checked: false},
    ]
  }
  componentDidMount(){
    fetch('api/v1/players/index')
      .then((response) => {return response.json()})
      .then((data) => {this.setState( {filteredUnselectedObjects: data, unselectedObjects: data })});
    this.requestStats()
    
  }
  requestStats = () => {
    var displayed_cats = [{text: 'Name', value: 'name'}]
    var length = this.state.categories.length;
    for (var i = 0; i < length; i++) {
      if (this.state.categories[i].checked) {
        displayed_cats.push({value: this.state.categories[i].value, text: this.state.categories[i].text})
      }
    }
    displayed_cats.push({text: 'Rating', value: 'score'})
    fetch('search', {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(this.getRequestBody()),
    }).then((response) => {return response.json()})
      .then((data) => {
        this.setState( {
          players_stats: data,
          displayed_categories: displayed_cats
        })
      });    
  }
  getRequestBody = () => {
    var categories = {}
    var arrayLength = this.state.categories.length;
    for (var i = 0; i < arrayLength; i++) {
      if (this.state.categories[i].checked) {
        categories[this.state.categories[i].value] = parseInt(this.state.categories[i].weight)
      }
    }
    var yahoo_positions=[]
    var arrayLength = this.state.positions.length
    for (var i = 0; i < arrayLength; i++) {
      if (this.state.positions[i].checked) {
        yahoo_positions.push(this.state.positions[i].name)
      }
    }
    var excluded_players=[]
    var arrayLength = this.state.selectedObjects.length
    for (var i = 0; i<arrayLength; i++) {
      excluded_players.push(this.state.selectedObjects[i].id)
    }
    var filters = {
      'age_between': [parseInt(this.state.ageRange[0]),parseInt(this.state.ageRange[1])],
      'years_in_league_between': [parseInt(this.state.yearsInLeague[0]), parseInt(this.state.yearsInLeague[1])],
      'yahoo_positions': yahoo_positions,
      'exclude_players': excluded_players
    }
    var average = 'true'
    var num_games = 82


    return {
      categories: categories,
      filters: filters,
      average: average,
      num_games: num_games,
      min_games: this.state.minGames
    }
  }
  handleDropDownClick = () => {
    this.setState((prevState) => ({
      droppedDown: !prevState.droppedDown
    }));
  }
  handleSearch = () => {
    this.requestStats()
  }
  filterList = (event) => {
    var updatedUnselectedList = this.state.unselectedObjects;
    updatedUnselectedList = updatedUnselectedList.filter(function(item){
      return item.name.toLowerCase().search(
      event.target.value.toLowerCase()) !== -1;
    });

    var updatedSelectedList = this.state.selectedObjects;
    updatedSelectedList = updatedSelectedList.filter(function(item){
      return item.name.toLowerCase().search(
      event.target.value.toLowerCase()) !== -1;
    });

    this.setState({
      filteredUnselectedObjects: updatedUnselectedList,
      filteredSelectedObjects: updatedSelectedList,
      filterValue: event.target.value
    })
  }

  handleSelect = (index) => {
    var obj = this.state.filteredUnselectedObjects[index]
    var newSelected = this.state.selectedObjects.slice()
    newSelected.push(obj)

    var newFilteredSelected = this.state.filteredSelectedObjects.slice()
    newFilteredSelected.push(obj)

    var newUnselected = this.state.unselectedObjects.slice()
    var originalIndex = newUnselected.indexOf(obj);
    newUnselected.splice(originalIndex, 1)
    var newFilteredUnselected = this.state.filteredUnselectedObjects.slice()
    newFilteredUnselected.splice(index, 1)
  
    this.setState({
      selectedObjects: newSelected,
      unselectedObjects: newUnselected,
      filteredUnselectedObjects: newFilteredUnselected,
      filteredSelectedObjects: newFilteredSelected
    });
  }
  
  handleUnselect = (index) => {
    var obj = this.state.filteredSelectedObjects[index]
    var newUnselected = this.state.unselectedObjects.slice()
    newUnselected.push(obj)

    var newFilteredUnselected = this.state.filteredUnselectedObjects.slice()
    newFilteredUnselected.push(obj)

    var newSelected = this.state.selectedObjects.slice()
    var originalIndex = newSelected.indexOf(obj);
    newSelected.splice(originalIndex, 1)
    var newFilteredSelected = this.state.filteredSelectedObjects.slice()
    newFilteredSelected.splice(index, 1)
  
    this.setState({
      selectedObjects: newSelected,
      unselectedObjects: newUnselected,
      filteredUnselectedObjects: newFilteredUnselected,
      filteredSelectedObjects: newFilteredSelected
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
  handleMinGamesChange = (event) => {
    this.setState({minGames: event.target.value});
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
        <button 
          type='button'
          onClick = {this.handleSearch}
          className="dropdown">
          Search
        </button>
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
            selectedObjects = {this.state.filteredSelectedObjects}
            filterValue = {this.state.filterValue}
            positions = {this.state.positions}
            handlePositionChange = {this.handlePositionChange}
            ageRange = {this.state.ageRange}
            handleRangeChange = {this.handleRangeChange}
            yearsInLeague = {this.state.yearsInLeague}
            numIncluded = {this.state.unselectedObjects.length}
            numExcluded = {this.state.selectedObjects.length}
            minGames = {this.state.minGames}
            handleMinGamesChange = {this.handleMinGamesChange}
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

      <PlayersStatsTable categories={this.state.displayed_categories} players={this.state.players_stats}/>
      </div>
    );
  }
}

export default SearchForm