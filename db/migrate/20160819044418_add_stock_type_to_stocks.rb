class AddStockTypeToStocks < ActiveRecord::Migration[5.0]
  def change
  	add_column :stocks, :stock_type, :integer
  end
end
