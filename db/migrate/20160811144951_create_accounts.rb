class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :code
      t.string :type

      t.timestamps
    end
  end
end
