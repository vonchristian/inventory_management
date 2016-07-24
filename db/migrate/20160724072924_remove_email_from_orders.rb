class RemoveEmailFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :email, :string
    remove_column :orders, :name, :string
    remove_column :orders, :address, :string
    remove_column :orders, :mobile_number, :string



  end
end
