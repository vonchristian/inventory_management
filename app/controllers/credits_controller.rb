class CreditsController < ApplicationController
  def index
    if params[:name].present?
      @members = Member.search_by_name(params[:name])
    else
      @members = Member.by_total_credit
    end
  end
end
