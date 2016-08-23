module Members
  class LineItemsController < ApplicationController
    def scope_to_date
      @member = Member.find(params[:member_id])
      @line_items = @member.line_items
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.now.beginning_of_day
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.now.end_of_day
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::LineItemsPdf.new(@member, @line_items, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Member's Purchases.pdf"
          pdf.print
        end
      end
    end
  end
end
