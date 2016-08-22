class Product < ApplicationRecord
  include PublicActivity::Common
  include PgSearch
  enum stock_status: [:available, :low_stock, :out_of_stock, :discontinued]
  pg_search_scope :search_by_name, :against => [:name, :bar_code]

  has_many :stocks, dependent: :destroy
  has_many :refunds, through: :stocks, dependent: :destroy
  has_many :line_items, through: :stocks, dependent: :destroy
  validates :name, presence: true

  before_destroy :ensure_not_referenced_by_any_line_item

  def quantity
    stocks.all.sum(:quantity) - line_items.all.sum(:quantity)
  end

  def in_stock
    stocks.sum(:quantity) - sold
  end

  def name_description
    if description.present?
      "#{name} #{description}"
    else
      "#{name}"
    end
  end

  def sold
   line_items.sum(:quantity)
  end

  def quantity_and_unit
    "#{quantity} #{unit}"
  end

  def out_of_stock?
    quantity.zero? || quantity.negative?
  end

  def low_stock?
    quantity <= stock_alert_count && !out_of_stock?
  end

  def stock_alert
    if out_of_stock?
      "Out of Stock"
    elsif low_stock?
      "Low"
    end
  end

  def set_stock_status
    if !out_of_stock? && !low_stock?
      self.available!
    elsif low_stock?
      self.low_stock!
    elsif out_of_stock?
      self.out_of_stock!
    end
  end

  # def check_stock_status
  #   return self.low_stock! if quantity < stock_alert_count && quantity > 0
  #   return self.out_of_stock! if self.out_of_stock?
  #   return self.available! if !out_of_stock? || !low_stock?
  # end

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
