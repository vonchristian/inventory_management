class RemoveQuantityFromLineItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :line_items, :quantity, :integer
  end
end
