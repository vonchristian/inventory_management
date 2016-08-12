class Cart < ApplicationRecord
  acts_as_paranoid
  belongs_to :employee
  has_many :line_items, dependent: :destroy
  has_many :stocks, through: :line_items

  def total_price
    line_items.to_a.sum { |item| item.total_cost }
  end

  def total_whole_sale_price
    line_items.to_a.sum { |item| item.total_whole_sale_price }
  end

  def add_line_item(line_item)
    if self.stocks.include?(line_item.stock)
        self.line_items.where(stock_id: line_item.stock.id).delete_all
        # replace with a single item
        self.line_items.create(stock_id: line_item.stock.id, quantity: line_item.quantity, pricing_type: line_item.pricing_type, unit_cost: line_item.unit_cost, total_cost: line_item.total_price)
      else
        self.line_items.create(stock_id: line_item.stock.id, quantity: line_item.quantity, pricing_type: line_item.pricing_type, unit_cost: line_item.unit_cost, total_cost: line_item.total_price)
      end
  end
end
