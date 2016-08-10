class AddTotalCostToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :total_cost, :decimal
  end
end
