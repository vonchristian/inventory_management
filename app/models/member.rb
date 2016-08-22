class Member < User
  enum role: [:member]
  has_many :orders
  has_many :line_items, through: :orders
  has_many :refunds
  def name
    full_name
  end
end
