class AddDefinitionToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :definition, :string
  end
end
