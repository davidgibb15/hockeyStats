// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require jquery-tablesorter
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery-ui


$(document).ready(function() {

	var slider = $("#age_slider").slider({
        range: true,
        min: 18,
        max: 50,
        values: [0, 50],
        slide: function(event, ui) {
            $("#data1").val(ui.values[0]);
            $("#data2").val(ui.values[1]);
            $( "#min-range" ).text( ui.values[0] );
            $( "#max-range" ).text( ui.values[1] );
        }
    });
    $("#data1").val(slider.slider("values")[0]);
    $("#data2").val(slider.slider("values")[1]);
    $( "#min-range" ).text( slider.slider("values")[0]);
    $( "#max-range" ).text( slider.slider("values")[1]);

    var slider = $("#years_slider").slider({
        range: true,
        min: 0,
        max: 27,
        values: [0, 27],
        slide: function(event, ui) {
            $("#data3").val(ui.values[0]);
            $("#data4").val(ui.values[1]);
            $( "#min-years" ).text( ui.values[0] );
            $( "#max-years" ).text( ui.values[1] );
        }
    });
    $("#data3").val(slider.slider("values")[0]);
    $("#data4").val(slider.slider("values")[1]);
    $( "#min-years" ).text( slider.slider("values")[0]);
    $( "#max-years" ).text( slider.slider("values")[1]);
});