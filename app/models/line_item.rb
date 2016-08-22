class LineItem < ApplicationRecord
  belongs_to :stock
  belongs_to :cart
  belongs_to :order
  belongs_to :user
  belongs_to :product
  enum pricing_type: [:retail, :wholesale]
<<<<<<< HEAD
  scope :created_between, lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date )}
=======
  enum pay_type:[:cash, :credit, :check]
>>>>>>> 9fefa95d56796da6c92ebb4b70791764d3017dc0

  validates :quantity, numericality: {less_than_or_equal_to: :stock_quantity }, on: :create
  delegate :name, :quantity, to: :stock, prefix: true
  delegate :pay_type, to: :order

<<<<<<< HEAD
  def self.cash
    all.select{|a| a.order.pay_type=='cash'}
  end
  def self.credit
      all.select{|a| a.order.pay_type=='credit'}
  end
=======
  after_commit :set_stock_status
  delegate :set_stock_status, to: :stock
>>>>>>> 9fefa95d56796da6c92ebb4b70791764d3017dc0

  def total_price
    return stock.retail_price * quantity if self.retail?
    return stock.wholesale_price * quantity if self.wholesale?
  end

  def total_whole_sale_price
    stock.wholesale_price * quantity
  end

  def self.total_whole_sale_price
    self.all.to_a.sum { |item| item.unit_cost }
  end

  def self.total_price
    self.all.to_a.sum { |item| item.total_price }
  end
end
