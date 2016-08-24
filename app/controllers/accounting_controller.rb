class AccountingController < ApplicationController
  def index
    @accounts = Accounting::Account.all.order(:code)
    first_entry = Accounting::Entry.order('date ASC').first
    @from_date = first_entry ? first_entry.date: Date.today
    @to_date = params[:date] ? DateTime.parse(params[:date]) : Date.today
    @assets = Accounting::Asset.active.all.order(:code)
    @liabilities = Accounting::Liability.active.all.order(:code)
    @equity = Accounting::Equity.active.all.order(:code)
    @revenues = Accounting::Revenue.all.order(:code)
    @expenses = Accounting::Expense.all.order(:code)
  end
end
