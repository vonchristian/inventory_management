class RemoveReasonToRefunds < ActiveRecord::Migration[5.0]
  def change
    remove_column :refunds, :reason, :integer
  end
end
