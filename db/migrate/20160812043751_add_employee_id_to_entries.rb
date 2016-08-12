class AddEmployeeIdToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :employee_id, :integer
    add_index :entries, :employee_id
  end
end
