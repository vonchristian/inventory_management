class RemoveDateFromEntries < ActiveRecord::Migration[5.0]
  def change
    remove_column :entries, :date, :date
    add_column  :entries, :date, :datetime
  end
end
