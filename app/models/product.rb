class Product < ApplicationRecord
  include PublicActivity::Common
  include PgSearch
  pg_search_scope :search_by_name, :against => :name

  has_many :line_items
  has_many :orders, through: :line_items
  has_many :stocks
  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0.1 }

  accepts_nested_attributes_for :stocks
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
  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      erros.add(:base, 'Line Items present')
      return false
    end
  end
end
