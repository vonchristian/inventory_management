class AddDateToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :date, :date
  end
end
