class AccountingController < ApplicationController
  def index
    @active_accounts = Accounting::Account.includes(:main_account).active.all.order(:code)
    @inactive_accounts = Accounting::Account.includes(:main_account).inactive.all.order(:code)

    first_entry = Accounting::Entry.order('date ASC').first
    @from_date = first_entry ? first_entry.date: Date.today
    @to_date = params[:date] ? DateTime.parse(params[:date]) : Date.today
    @assets = Accounting::Asset.active.all.order(:code)
    @liabilities = Accounting::Liability.active.all.order(:code)
    @equity = Accounting::Equity.active.all.order(:code)
    @revenues = Accounting::Revenue.all.order(:code)
    @expenses = Accounting::Expense.all.order(:code)
    @entries = Accounting::Entry.all.order(:date)
  end
end
