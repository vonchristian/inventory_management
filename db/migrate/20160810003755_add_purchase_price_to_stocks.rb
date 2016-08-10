class AddPurchasePriceToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :purchase_price, :decimal
  end
end
