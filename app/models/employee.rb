class Employee < User
  enum role: [:cashier, :stock_custodian, :bir_officer, :proprietor, :bookkeeper, :accountant]
end
