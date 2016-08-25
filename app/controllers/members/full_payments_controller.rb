module Members
  class FullPaymentsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @entry = Accounting::Entry.new
      authorize @entry
      @entry.debit_amounts.build
      @entry.credit_amounts.build
    end

    def create
      @member = Member.find(params[:member_id])
      @entry = Accounting::Entry.create(entry_params)
      @entry.commercial_document = @member
      @entry.recorder = current_user
      if @entry.save
        @member.set_credits_to_paid
        redirect_to @member, notice: "Payment saved successfully."
      else
        render :new
      end
      authorize @entry
    end

    def show
      @entry = Accounting::Entry.find(params[:id])
    end

    private
    def entry_params
      params.require(:accounting_entry).permit(:date, :description, :reference_number, debit_amounts_attributes:[:amount, :account], credit_amounts_attributes:[:amount, :account])
    end
  end
end
