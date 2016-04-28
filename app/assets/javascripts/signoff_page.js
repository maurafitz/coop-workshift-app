$(document).ready(function() {
  $("#workshifter").change(function(){
    $.getJSON( "/signoffs/" + $(this).val() + "/get_shifts", function( data ) {
      html = ''
      $.each(data, function(key,value){
        html += '<option data-hour="' + value["hours"] +  '" value="' + key + '">' + value["description"] + '</option>';
      }) 
      $("#pers_shifts").find('option').remove().end().append(html)
      var options = $("#pers_shifts option");                    // Collect options         
      options.detach().sort(function(a,b) {               // Detach from select, then Sort
          var at = $(a).text();
          var bt = $(b).text();         
          return (at > bt)?1:((at < bt)?-1:0);            // Tell the sort function how to order
      });
      options.appendTo("#pers_shifts");
      $("#pers_shifts").selectpicker("refresh")
      $("#pers_shifts").trigger("change");
    });
  });
  
  $("#pers_shifts").change(function(){
    $("#pers_shifts_hr").val( $(this).find(":selected").data("hour") );
  });
  
  $("#workshifter").trigger("change");
  
  $("#dates").change(function(){
    $.getJSON( "/signoffs/get_all_shifts", function( data ) {
      html = '';
      data = data[$("#dates").val()]
      $.each(data, function(key,value){
        html += '<option value="' + key + '">' + key + '</option>';
      }) 
      $("#shifts").find('option').remove().end().append(html)
      var options = $("#shifts option");                    // Collect options         
      options.detach().sort(function(a,b) {               // Detach from select, then Sort
          var at = $(a).text();
          var bt = $(b).text();         
          return (at > bt)?1:((at < bt)?-1:0);            // Tell the sort function how to order
      });
      options.appendTo("#shifts");
      $("#shifts").selectpicker("refresh").trigger("change");
    });
  });
  
  $("#shifts").change(function(){
    $.getJSON( "/signoffs/get_all_shifts", function( data ) {
      html = '';
      data = data[$("#dates").val()][$("#shifts").val()];
      $.each(data, function(key, dict){
        hours = dict["hours"]
        html += '<option value="' + dict["shift_id"] + '">' + dict["name"] + '</option>';
      }) 
      $("#person").find('option').remove().end().append(html)
      var options = $("#person option");                    // Collect options         
      options.detach().sort(function(a,b) {               // Detach from select, then Sort
          var at = $(a).text();
          var bt = $(b).text();         
          return (at > bt)?1:((at < bt)?-1:0);            // Tell the sort function how to order
      });
      options.appendTo("#person");
      $("#person").selectpicker("refresh");
      $("#all_shifts_hr").val( hours );
    });
  });
  
  $.getJSON( "/signoffs/get_all_shifts", function( data ) {
      html = '';
      $.each(data, function(key,value){
        html += '<option value="' + key + '">' + key + '</option>';
      }) 
      $("#dates").append(html)
      var options = $("#dates option");                    // Collect options         
      options.detach().sort(opt_dateSorter);
      options.appendTo("#dates");
      $("#dates").selectpicker("refresh").trigger("change");
  });
  
  $("a").click(function(){
    $("#form_type").val( $(this).attr('id') );
  })

  $("#email_form").validator();
  
  $(".email_link").click(function(){
    html ="<ul>"
    shift_id = $(this).data("id");
    $("#" + shift_id).find("td").each(function(ind) {
      if(ind < 3){
        var info = $(this).text();
        html += "<li>" + info + "</li>";
      }
    });
    html += "</ul>";
    
    $("#shift_info_email").append(html);
  });
  
  $('.selectpicker-signoff').selectpicker();
  
  $.fn.sortOptions = function(sort_fn){
    $(this).each(function(){
        var op = $(this).children("option");
        console.log("Original")
        console.log(op)
        console.log()
        op.sort()
        return $(this).empty().append(op);
        console.log("sorted")
        console.log(op)
    });
  }
  // $(".shift_sort").sortOptions(shiftSorter);

  // $(".date_sort").sortOptions(dateSorter);
});