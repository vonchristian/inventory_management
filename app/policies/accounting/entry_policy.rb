module Accounting
  class EntryPolicy < ApplicationPolicy
    def initialize(employee, entry)
      @employee = employee
      @entry = entry
    end
    def index?
      @employee.bookkeeper?
    end
    def new?
      create?
    end
    def create?
      @employee.bookkeeper?
    end
  end
end
