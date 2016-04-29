class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items
  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0.1 }

  before_destroy :ensure_not_referenced_by_any_line_item

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
