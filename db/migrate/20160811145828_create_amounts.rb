class CreateAmounts < ActiveRecord::Migration[5.0]
  def change
    create_table :amounts do |t|
      t.string :type
      t.references :account, foreign_key: true
      t.references :entry, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
    add_index :amounts, :type
  end
end
