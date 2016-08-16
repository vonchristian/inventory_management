class Employee < User
  enum role: [:cashier, :stock_custodian, :bir_officer, :proprietor, :bookkeeper, :accountant]
  has_many :orders
  has_many :line_items, through: :orders
  has_many :refunds
  def name
    full_name
  end
end
