class StoreController < ApplicationController
    def index
      if params[:name].present?
        @products = Product.search_by_name(params[:name])
      else
        @products = Product.all
      end
    @cart = current_cart
    @line_item = LineItem.new
  end
end
