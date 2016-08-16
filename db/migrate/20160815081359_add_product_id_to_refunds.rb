class AddProductIdToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :stock_id, :integer
    add_index :refunds, :stock_id
  end
end
