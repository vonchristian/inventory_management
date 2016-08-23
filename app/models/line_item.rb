class LineItem < ApplicationRecord
  acts_as_paranoid
  belongs_to :stock
  belongs_to :cart
  belongs_to :order
  belongs_to :employee, foreign_key: 'user_id'
  enum pricing_type: [:retail, :wholesale]
  enum payment_type: [:cash, :credit]
  # scope :created_between, lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date )}

  validates :quantity, numericality: {less_than_or_equal_to: :stock_quantity }, on: :create
  delegate :name, :quantity, to: :stock, prefix: true

  def self.created_between(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : DateTime.parse(hash[:from_date])
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : DateTime.parse(hash[:to_date])
      where('created_at' => from_date..to_date)
    else
      all
    end
end


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
