class StocksPolicy < ApplicationPolicy
  def initialize(employee, stock)
    @employee = employee
    @stock = stock
  end

  def index?
    employee.stock_custodian?
  end
end
