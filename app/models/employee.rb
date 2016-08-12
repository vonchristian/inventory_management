class Employee < User
  enum role: [:cashier, :stock_custodian, :bir_officer, :proprietor, :bookkeeper, :accountant]
  def name
    full_name
  end
end
