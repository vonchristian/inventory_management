class Product < ApplicationRecord
  include PublicActivity::Common
  include PgSearch
  enum stock_status: [:available, :low_stock, :out_of_stock, :discontinued]
  pg_search_scope :search_by_name, :against => [:name, :bar_code]

  has_many :line_items
  has_many :orders, through: :line_items
  has_many :stocks
  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0.1 }

  before_destroy :ensure_not_referenced_by_any_line_item

  def quantity
    stocks.all.sum(:quantity) - line_items.all.sum(:quantity)
  end


  def quantity_and_unit
    "#{quantity} #{unit}"
  end
  def out_of_stock?
    quantity.zero? || quantity.negative?
  end
  def nearing_out_of_stock?
    if stock_alert_count
    quantity <= stock_alert_count
  else
    false
  end
  end
  def stock_alert
    if out_of_stock?
      "Out of Stock"
    elsif nearing_out_of_stock?
      "Low"
    end
  end
  def check_stock_status
    return self.low_stock! if quantity < stock_alert_count && quantity > 0
    return self.out_of_stock! if self.out_of_stock?
    return self.available! if !out_of_stock? || !low_stock?
  end
  def set_product_as_available
    self.available!
  end
  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
end
