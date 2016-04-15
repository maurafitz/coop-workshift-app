$(document).ready(function() {
    $('.selectpicker').each(function(){
        val = $(this).data("status");
        if(val != ""){
            $(this).selectpicker("val", val);
        }
    });
});
