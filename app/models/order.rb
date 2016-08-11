class Order < ApplicationRecord
  belongs_to :member, foreign_key: 'user_id'
  enum pay_type:[:cash, :credit, :check]
  enum order_type: [:retail, :wholesale]
  enum delivery_type: [:pick_up, :deliver, :to_go]
  has_many :line_items, dependent: :destroy
  has_many :credit_payments
  before_save :set_date, :set_user

  validates :user_id, presence: true
  def self.total_amount
    all.map{|a| a.total_amount }.sum
  end
  def tax_rate
    if business.non_vat_registered?
      0.03
    elsif business.vat_registered?
      0.12
    end
  end
  def total_amount
    line_items.sum(:total_cost)
  end
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
  def set_user
    if user_id.nil?
      user_id = User.find_by_first_name('Guest').id
    end
  end
end
