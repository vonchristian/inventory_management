class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  def total_price
    product.price * quantity
  end

  def self.total_price
      self.all.to_a.sum { |item| item.total_price }
  end
end
