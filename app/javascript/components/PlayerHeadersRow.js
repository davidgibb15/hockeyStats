import React from "react"
import ButtonHeader from "./ButtonHeader"
class PlayerHeadersRow extends React.Component {
  render() {
    return(
      <tr>
       {this.props.headerNames.map(headerName => <ButtonHeader key={headerName} headerName={headerName} onClickFunction= {this.props.onClickFunction} /> )}
      </tr>
    )
  }
}
export default PlayerHeadersRow