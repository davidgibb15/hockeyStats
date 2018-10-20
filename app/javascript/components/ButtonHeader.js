import React from "react"

class ButtonHeader extends React.Component {
  render(){
    return (
      <th>
        <button onClick={() => this.props.onClickFunction(this.props.headerName)}>
          {this.props.headerName}
        </button>
      </th>
    );
  }
}

export default ButtonHeader