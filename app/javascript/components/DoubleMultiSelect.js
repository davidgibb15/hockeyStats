import React from "react"
import MultiSelect from "./MultiSelect"
class DoubleMultiselect extends React.Component {
  state = { 
    unselectedVisible: false,
    selectedVisible: false
  }

  handleDropDownClick = (state_name) => {
    this.setState((prevState) => ({
      [state_name]: !prevState[state_name]
    }));
  }

  render() {
    return(
      <div>
        <div>
          <input className={this.state.unselectedVisible || this.state.selectedVisible ? 'visible' : 'visible'} type="text" onChange={this.props.filterList} value={this.props.filterValue}/>
        </div>
        <div className='unselected-wrapper'>
          <button 
            type='button'
            onClick = {() => this.handleDropDownClick('unselectedVisible')}
            className="dropdown">
            Included players ({this.props.numIncluded})
          </button>
          <div className={this.state.unselectedVisible ? 'visible' : 'hidden'}>
                 
            <MultiSelect class={"unselected"} objects={this.props.unselectedObjects} onClickFunction={this.props.handleSelect}/>
          </div>
        </div>
        <div className='selected-wrapper'>
          <button 
            type='button'
            onClick = {() => this.handleDropDownClick('selectedVisible')}
            className="dropdown">
            Excluded players ({this.props.numExcluded})
          </button>
          <div className={this.state.selectedVisible ? 'visible' : 'hidden'}>
            <MultiSelect class={"selected"} objects={this.props.selectedObjects} onClickFunction={this.props.handleUnselect}/>
          </div>
        </div>
      </div>
    );
  }
}

export default DoubleMultiselect