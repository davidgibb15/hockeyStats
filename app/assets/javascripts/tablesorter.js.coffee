$(document).ready ->
  console.log("hello")
  $ ->
    $.extend $.tablesorter.defaults,
      widgets: [
        "zebra"
        "columns"
        "stickyHeaders"
      ]

    $("#myTable").tablesorter()

return