class AddContraToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :contra, :boolean
  end
end
