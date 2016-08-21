class RemoveReceiptNumberFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :receipt_number, :string
  end
end
