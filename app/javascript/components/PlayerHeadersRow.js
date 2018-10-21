import React from "react"
import ButtonHeader from "./ButtonHeader"
class PlayerHeadersRow extends React.Component {
  render() {
  	console.log(this.props)
    return(
      <tr>
       {this.props.categories.map(headerName => <ButtonHeader key={headerName.value} headerName={headerName.text} value={headerName.value} onClickFunction= {this.props.onClickFunction} /> )}
      </tr>
    )
  }
}
export default PlayerHeadersRow