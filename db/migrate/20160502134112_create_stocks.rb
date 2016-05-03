class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.decimal :quantity, scale: 2, precision: 8
      t.datetime :date
      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
