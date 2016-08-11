class AddEntryToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :entry, foreign_key: true
  end
end
