class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  validates :quantity, numericality: { less_than_or_equal_to: :product_quantity }

  delegate :name, to: :product, prefix: true
  def product_quantity
    product.quantity
  end
  def total_price
    product.price * quantity
  end

  def self.total_price
      self.all.to_a.sum { |item| item.total_price }
  end
end
