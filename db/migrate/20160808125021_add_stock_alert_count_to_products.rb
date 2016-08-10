class AddStockAlertCountToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :stock_alert_count, :decimal
  end
end
