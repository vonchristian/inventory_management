class AddReferenceNumberToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :reference_number, :string
  end
end
