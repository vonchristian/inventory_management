class AddDiscountedToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :discounted, :boolean, default: false
  end
end
