import React from "react"
import DoubleMultiSelect from "./DoubleMultiSelect"

class Filters extends React.Component {

  handlePositionChange = index => event => { 
    this.props.handlePositionChange(event, index)
  }
  handleRangeChange = (index, name) => event => {
    this.props.handleRangeChange(event, index, name)
  }

  render() {
    return (
      <div className="filters-container">
        <div className="multiselect-container">
          <DoubleMultiSelect 
            handleUnselect = {this.props.handleUnselect}
            handleSelect = {this.props.handleSelect}
            filterList = {this.props.filterList}
            unselectedObjects = {this.props.unselectedObjects}
            selectedObjects = {this.props.selectedObjects}
            filterValue = {this.props.filterValue}
            numIncluded = {this.props.numIncluded}
            numExcluded = {this.props.numExcluded}
          />
        </div>
        <div className="sub-filters">
          {
            this.props.positions.map((position, index) => (
              <span key={index}>
              {position.name}
              <input type="checkbox"
                key={position.name}
                checked={position.checked}
                name={position.name}
                onChange = { this.handlePositionChange(index) }
              />
              </span>
            ))
          }
          <div className="age-range">
            Ages
            <input type="number"
              value={this.props.ageRange[0]}
              name="minimum-age"
              onChange={this.handleRangeChange(0, 'ageRange')}
            />
            -
            <input type="number"
              value={this.props.ageRange[1]}
              name="maximim-age"
              onChange={this.handleRangeChange(1, 'ageRange')}
            />
          </div>
        <div className="yol-range">
          Years In League 
          <input type="number"
            value={this.props.yearsInLeague[0]}
            name="minimum-years"
            onChange={this.handleRangeChange(0, 'yearsInLeague')}
          />
          -
          <input type="number"
            value={this.props.yearsInLeague[1]}
            name="maximum-years"
            onChange={this.handleRangeChange(1, 'yearsInLeague')}
          />
        </div>
        <div className="min-games">
          Minimum Games
          <input type="number"
            value={this.props.minGames}
            name="minimum-games"
            onChange={this.props.handleMinGamesChange}
          />
        </div>
      </div>
    </div>
    );
  }
}

export default Filters