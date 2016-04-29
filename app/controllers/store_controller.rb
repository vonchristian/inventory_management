class StoreController < ApplicationController
  def index
    @products = Product.order(:name)
    @cart = current_cart
  end
end
