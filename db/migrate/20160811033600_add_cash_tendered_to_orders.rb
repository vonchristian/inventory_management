class AddCashTenderedToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cash_tendered, :decimal
    add_column :orders, :change, :decimal
  end
end
