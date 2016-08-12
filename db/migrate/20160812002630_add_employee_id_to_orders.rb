class AddEmployeeIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :employee_id, :integer
    add_index :orders, :employee_id
  end
end
