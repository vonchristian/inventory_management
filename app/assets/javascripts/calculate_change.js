function calculateChange() {
  var myBox2 = document.getElementById('total').value;
  var myBox1 = document.getElementById('order_cash_tendered').value;
  var result = document.getElementById('order_change');
  var myResult = myBox1 - myBox2;
  result.value = myResult;
}
