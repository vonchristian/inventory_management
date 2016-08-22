class Member < User
<<<<<<< HEAD
  enum role: [:customer]
  def to_s
=======
  enum role: [:member]
  has_many :orders
  has_many :line_items, through: :orders
  has_many :refunds
  def name
>>>>>>> 9fefa95d56796da6c92ebb4b70791764d3017dc0
    full_name
  end
end
