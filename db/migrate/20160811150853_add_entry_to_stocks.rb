class AddEntryToStocks < ActiveRecord::Migration[5.0]
  def change
    add_reference :stocks, :entry, foreign_key: true
  end
end
