module Accounting
  class EntriesController < ApplicationController
    def index
      if params[:query].present?
      @entries = Accounting::Entry.search_by_name(params[:query]).order(:date).page(params[:page]).per(30)

    else
      @entries = Accounting::Entry.includes(:commercial_document, :recorder).all.order('date DESC').page(params[:page]).per(30)
      @from_date = params[:from_date] ? Time.parse(params[:from_date]) : Time.now.beginning_of_day
      @to_date = params[:to_date] ? Time.parse(params[:to_date]) : Time.now.end_of_day
      respond_to do |format|
        format.html
        format.pdf do
          pdf = EntriesPdf.new(@entries, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries Report.pdf"
        end
      end
    end
    authorize @entries
  end

    def new
      @entry = Accounting::Entry.new
      authorize @entry
      @entry.debit_amounts.build
      @entry.credit_amounts.build
    end

    def create
      @entries = Accounting::Entry.all
      @entry = Accounting::Entry.create(entry_params)
      @entry.recorder = current_user
      authorize @entry
    end

    def show
      @entry = Accounting::Entry.find(params[:id])
    end
    def scope_to_date
      @entries = Accounting::Entry.created_between(params[:from_date], params[:to_date])
      @from_date = params[:from_date] ? Time.parse(params[:from_date]) : Time.now.beginning_of_day
      @to_date = params[:to_date] ? Time.parse(params[:to_date]) : Time.now.end_of_day
      respond_to do |format|
        format.html
        format.pdf do
          pdf = EntriesPdf.new(@entries, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries Report.pdf"
        end
      end
    end

    private
    def entry_params
      params.require(:accounting_entry).permit(:date, :description, :reference_number, debit_amounts_attributes:[:amount, :account], credit_amounts_attributes:[:amount, :account])
    end
  end
end
