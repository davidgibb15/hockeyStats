import React from "react"

class StatSelect extends React.Component {
  onCheckChange = index => e =>{ 
    this.props.onCheckChange(index)
  }
  onWeightChange = index => event =>{ 
    this.props.onWeightChange(event, index)
  }
  render() {
    return (
      <div className="statContainer">
        <input type="checkbox"
        checked={this.props.checked}
        name={this.props.name}
        onChange = {this.onCheckChange(this.props.index)}
        />
        {this.props.name}
        <input type="number" 
        value={this.props.weight}
        onChange= {this.onWeightChange(this.props.index)}
        step="0.1" />
      </div>
    );
  }
}
export default StatSelect