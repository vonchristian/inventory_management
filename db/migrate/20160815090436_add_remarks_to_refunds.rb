class AddRemarksToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :remarks, :string
  end
end
