class CreateRefunds < ActiveRecord::Migration[5.0]
  def change
    create_table :refunds do |t|
      t.decimal :amount
      t.integer :reason
      t.integer :request_status

      t.timestamps
    end
  end
end
