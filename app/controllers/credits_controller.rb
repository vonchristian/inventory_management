class CreditsController < ApplicationController
  def index
    if params[:name].present?
      @orders = Order.search_by_name(params[:name])
    else
      @orders = Order.credit
    end
  end
end
