class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order
  belongs_to :user
  enum pricing_type: [:retail, :wholesale]

  validates :quantity, numericality: {less_than_or_equal_to: :product_quantity }, on: :create
  after_commit :check_stock_status

  delegate :name, :quantity, to: :product, prefix: true
  delegate :check_stock_status, to: :product

  def total_price
    return product.price * quantity if self.retail?
    return product.wholesale_price * quantity if self.wholesale?
  end

  def total_whole_sale_price
    product.wholesale_price * quantity
  end
  def self.total_whole_sale_price
      self.all.to_a.sum { |item| item.unit_cost }
  end

  def self.total_price
      self.all.to_a.sum { |item| item.total_price }
  end
end
