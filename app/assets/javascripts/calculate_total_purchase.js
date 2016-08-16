function calculateTotalPurchase() {
  var quantity = document.getElementById('stock_quantity').value;
  var unitPrice = document.getElementById('stock_unit_price').value;

  var totalPurchasePrice = document.getElementById('stock_purchase_price');
  var myResult = quantity * unitPrice;
  totalPurchasePrice.value = myResult;
}
