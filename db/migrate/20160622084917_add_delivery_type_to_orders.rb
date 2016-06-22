class AddDeliveryTypeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :delivery_type, :integer
  end
end
