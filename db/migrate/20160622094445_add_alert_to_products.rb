class AddAlertToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :alert, :boolean
    add_column :products, :alert_number, :integer
  end
end
