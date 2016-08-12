class CreateWarranties < ActiveRecord::Migration[5.0]
  def change
    create_table :warranties do |t|
      t.string :description
      t.integer :business_id, index: true, foreign_key: true

      t.timestamps
    end
  end
end
