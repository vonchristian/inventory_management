document.addEventListener("turbolinks:load", function() {
  $('.datepicker').datepicker({
  format: "yyyy/mm/dd/",
  orientation: "auto bottom",
  todayHighlight: 'true',
  autoclose: 'true'
  });
});
