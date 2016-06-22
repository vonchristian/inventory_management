class Order < ApplicationRecord
  enum pay_type:[:cash, :credit]
  enum delivery_type: [:pick_up, :deliver, :to_go]
  has_many :line_items, dependent: :destroy

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
