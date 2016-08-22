class AddTotalQuantityToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :total_quantity, :decimal, default: 0
  end
end
