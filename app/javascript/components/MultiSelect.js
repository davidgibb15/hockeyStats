import React from "react"
class MultiSelect extends React.Component {
  onClickFunction = index => e => {
    this.props.onClickFunction(index)
  }
  render(){
    return(
      <ul className={this.props.class}>
        {this.props.objects.map((object, index) => <li key={object.id} onClick = {this.onClickFunction(index)}>{object.name}</li>)}
      </ul>
    );
  }
}
export default MultiSelect