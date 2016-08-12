class AddDeletedAtToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :deleted_at, :datetime
    add_index :entries, :deleted_at
  end
end
