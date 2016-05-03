class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  validates :quantity, numericality: { less_than_or_equal_to: :product_quantity }
  delegate :quantity, to: :product, prefix: true
  def total_price
    product.price * quantity
  end

  def self.total_price
      self.all.to_a.sum { |item| item.total_price }
  end
end
