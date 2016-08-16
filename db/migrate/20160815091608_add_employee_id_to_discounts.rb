class AddEmployeeIdToDiscounts < ActiveRecord::Migration[5.0]
  def change
    add_column :discounts, :employee_id, :integer
    add_index :discounts, :employee_id
  end
end
