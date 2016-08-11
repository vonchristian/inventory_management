class AddMainAccountIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :main_account_id, :integer
    add_index :accounts, :main_account_id
  end
end
