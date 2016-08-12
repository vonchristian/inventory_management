module Accounting
  class AccountPolicy < ApplicationPolicy
    def initialize(employee, account)
      @employee = employee
      @account = account
    end
    def index?
      @employee.bookkeeper?
    end
  end
end
