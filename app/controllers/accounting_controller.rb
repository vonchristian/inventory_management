class AccountingController < ApplicationController
  def index
    @accounts = Accounting::Account.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
    first_entry = Accounting::Entry.order('date ASC').first
    @from_date = first_entry ? first_entry.date: Date.today
    @to_date = params[:date] ? DateTime.parse(params[:date]) : Date.today
    @assets = Accounting::Asset.active.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
    @liabilities = Accounting::Liability.active.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
    @equity = Accounting::Equity.active.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
    @revenues = Accounting::Revenue.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
    @expenses = Accounting::Expense.includes([:credit_amounts, :debit_amounts, :main_account]).all.order(:code)
  end
end
