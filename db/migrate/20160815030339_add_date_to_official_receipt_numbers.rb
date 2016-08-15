class AddDateToOfficialReceiptNumbers < ActiveRecord::Migration[5.0]
  def change
    add_column :official_receipt_numbers, :date, :date
    add_column :invoice_numbers, :date, :date

  end
end
