class AddEmployeeIdToToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :employee_id, :integer
    add_index :refunds, :employee_id
  end
end
