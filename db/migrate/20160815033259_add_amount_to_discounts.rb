class AddAmountToDiscounts < ActiveRecord::Migration[5.0]
  def change
    add_column :discounts, :amount, :decimal
  end
end
