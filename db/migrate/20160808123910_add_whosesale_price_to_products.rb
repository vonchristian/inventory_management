class AddWhosesalePriceToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :wholesale_price, :decimal
  end
end
