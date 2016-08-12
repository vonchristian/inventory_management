class AddDeletedByToCarts < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :employee_id, :integer
    add_index :carts, :employee_id
  end
end
