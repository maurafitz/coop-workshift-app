// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// require jquery_ujs
//= require bootstrap
//= require bootstrap.file-input
// require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/jquery.dataTables
//= require turbolinks

//= require moment
//= require validator
//= require bootstrap-datepicker
//= require typeahead.bundle.min
//= require fixed-header


// Added by us - sprockets

// require treecompiles each of the other Javascript files
// in the javascripts directory and any subdirectories. 
// If you require bootstrap-sprockets after everything else, 
// your other scripts may not have access to the Bootstrap functions.
// require_tree .

var dateSorter = function (a, b) {
    var matcher = "dddd M/D";
    return compareDates(a, b, matcher);
};
var opt_dateSorter = function (a, b) {
    var matcher = "dddd M/D";
    return compareDates( $(a).text(), $(b).text(), matcher);
};

var timeSorter = function(a, b) {
    var matcher = "h:mma dddd M/D";
    return compareDates(a, b, matcher);
};

var shiftSorter = function(a, b) {
    var matcher = "M/D";
    a_split = a.split(" ");
    b_split = b.split(" ");
    date_comp = compareDates(a_split[0], b_split[0], matcher);
    if (date != 0){
        return date_comp
    } else {
        if(a_split[1] < b_split[1]) {
            return -1;
        }else{
            return 1;
        }
    }
};

var compareDates = function(a, b, matcher) {
    a = moment(a, matcher);
    b = moment(b, matcher);
    if (a.isAfter(b)) return 1;
    if (a.isBefore(b)) return -1;
    return 0;
}

$(document).ready(function() {
    $(".alert").fadeTo(5000, 500).slideUp(500, function(){
        $(".alert").alert('close');
    });
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
});