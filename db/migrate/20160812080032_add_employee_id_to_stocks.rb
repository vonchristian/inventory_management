class AddEmployeeIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :employee_id, :integer
    add_index :stocks, :employee_id
  end
end
