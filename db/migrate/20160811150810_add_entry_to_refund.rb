class AddEntryToRefund < ActiveRecord::Migration[5.0]
  def change
    add_reference :refunds, :entry, foreign_key: true
  end
end
