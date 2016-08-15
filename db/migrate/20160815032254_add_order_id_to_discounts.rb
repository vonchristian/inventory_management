class AddOrderIdToDiscounts < ActiveRecord::Migration[5.0]
  def change
    add_column :discounts, :order_id, :integer
  end
end
