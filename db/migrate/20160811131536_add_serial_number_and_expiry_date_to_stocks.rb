class AddSerialNumberAndExpiryDateToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :serial_number, :string
    add_column :stocks, :expiry_date, :date
  end
end
