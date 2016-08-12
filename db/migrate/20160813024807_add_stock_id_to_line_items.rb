class AddStockIdToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :stock_id, :integer
    remove_column :line_items, :product_id, :integer
    add_index :line_items, :stock_id
  end
end
