$(document).ready(function(){
  $("#discount_field").hide();
  $("#order_discount").change(function() {
    if($(this).is(":checked")) {
      $("#discount_field").show(300);
    } else {
      $("#discount_field").hide(200);
    }
  });
});