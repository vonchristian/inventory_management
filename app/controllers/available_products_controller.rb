class AvailableProductsController < ApplicationController
  def index
    @products = Product.available
  end
end
