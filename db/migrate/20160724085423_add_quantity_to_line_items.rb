class AddQuantityToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :quantity, :decimal, default: 1
  end
end
