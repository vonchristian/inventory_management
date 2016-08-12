class AddUnitPriceToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :unit_price, :decimal
  end
end
