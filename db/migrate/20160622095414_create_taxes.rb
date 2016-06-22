class CreateTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :taxes do |t|
      t.integer :tax_type
      t.string :name
      t.decimal :percent

      t.timestamps
    end
  end
end
