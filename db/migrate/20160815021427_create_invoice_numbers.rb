class CreateInvoiceNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_numbers do |t|
      t.belongs_to :order, foreign_key: true
      t.string :number

      t.timestamps
    end
  end
end
