class AddNameToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :name, :string
    add_column :stocks, :retail_price, :decimal
    add_column :stocks, :wholesale_price, :decimal
  end
end
