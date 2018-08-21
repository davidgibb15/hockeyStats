$(document).ready ->
  $ ->
    $.extend $.tablesorter.defaults,
      widgets: [
        "zebra"
        "columns"
        "stickyHeaders"
      ]

    $("#myTable").tablesorter()

return