class AddQuantityToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :quantity, :decimal
  end
end
