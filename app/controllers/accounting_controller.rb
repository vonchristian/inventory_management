class AccountingController < ApplicationController
  def index
    @accounts = Accounting::Account.all.order(:code)
  end
end
