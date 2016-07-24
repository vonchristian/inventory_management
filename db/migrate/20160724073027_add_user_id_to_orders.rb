class AddUserIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :user_id, :integer, foreign_key: true
    add_index :orders, :user_id
  end
end
