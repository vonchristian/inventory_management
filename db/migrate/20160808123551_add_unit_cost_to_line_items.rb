class AddUnitCostToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :unit_cost, :decimal
  end
end
