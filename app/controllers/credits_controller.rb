class CreditsController < ApplicationController
  def index
    if params[:name].present?
      @members = Member.search_by_name(params[:name])
    else
      @members = Member.by_total_credit
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Accounting::DueFromCustomersPdf.new(@members, view_context)
                send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Products Report.pdf"
        end
      end
    end
  end
end
