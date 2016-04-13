$(document).ready(function() {
    $("#pref_form").validator();
    $("#avail_form").validator();
    $('.selectpicker').selectpicker();
    $('.selectpicker').on('rendered.bs.select', function(e) {
        // do something...
        v = $(this).val()
        
        $(this).selectpicker('setStyle', 'btn-success', "remove");
        $(this).selectpicker('setStyle', 'btn-danger', "remove");
        $(this).selectpicker('setStyle', 'btn-warning', "remove");
        $(this).selectpicker('setStyle', 'btn-info', "remove");
        if (v == "Available") {
            $(this).selectpicker('setStyle', 'btn-success');
        }
        else if (v == "Unavaiable") {
            $(this).selectpicker('setStyle', 'btn-danger');
        }
        else if (v == "Not Preferred") {
            $(this).selectpicker('setStyle', 'btn-warning');
        }
        else if (v == "Unsure") {
            $(this).selectpicker('setStyle', 'btn-info');
        }
    });
});
