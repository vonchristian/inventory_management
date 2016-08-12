class ProductPolicy < ApplicationPolicy
  def initialize(employee, product)
    @employee = employee
    @product = product
  end
  def index?
    true
  end
  def new?
    create?
  end
  def create?
    @employee.stock_custodian?
  end
end
