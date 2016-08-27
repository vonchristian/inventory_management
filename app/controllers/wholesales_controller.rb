class WholesalesController < ApplicationController
  def index
    if params[:name].present?
      @stocks = Stock.search_by_name(params[:name])
    else
      @stocks = Stock.all
    end
    authorize :store
  @cart = current_cart
  @line_item = LineItem.new
  @order = Order.new
  @order.build_discount
end
end
