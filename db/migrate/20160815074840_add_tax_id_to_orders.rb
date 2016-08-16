class AddTaxIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :tax_id, :integer
    add_index :orders, :tax_id
  end
end
