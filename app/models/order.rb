class Order < ApplicationRecord
  belongs_to :member, foreign_key: 'user_id'
  enum pay_type:[:cash, :credit]
  enum order_type: [:retail, :wholesale]
  enum delivery_type: [:pick_up, :deliver, :to_go]
  has_many :line_items, dependent: :destroy
  has_many :credit_payments
  before_save :set_date
  
  validates :user_id, presence: true
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  private
  def set_date
    self.date = Time.zone.now
  end
end
