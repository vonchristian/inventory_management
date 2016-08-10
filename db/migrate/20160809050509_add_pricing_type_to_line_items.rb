class AddPricingTypeToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :pricing_type, :integer, default: 0
  end
end
