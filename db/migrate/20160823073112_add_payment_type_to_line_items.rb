class AddPaymentTypeToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :payment_type, :integer
  end
end
