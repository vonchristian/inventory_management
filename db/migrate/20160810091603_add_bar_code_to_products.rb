class AddBarCodeToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :bar_code, :string
  end
end
