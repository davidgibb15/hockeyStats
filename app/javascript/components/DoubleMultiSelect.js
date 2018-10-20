import React from "react"
import MultiSelect from "./MultiSelect"
class DoubleMultiselect extends React.Component {
  render() {  
    return(
      <div>
        <div className="unselected-wrapper">
          <input type="text" onChange={this.props.filterList} value={this.props.filterValue}/>
          <MultiSelect class={"unselected"} objects={this.props.unselectedObjects} onClickFunction={this.props.handleSelect}/>
         </div>
        <span className="selected-wrapper">
          <MultiSelect class={"selected"} objects={this.props.selectedObjects} onClickFunction={this.props.handleUnselect}/>
            </span>
      </div>
    );
  }
}

export default DoubleMultiselect