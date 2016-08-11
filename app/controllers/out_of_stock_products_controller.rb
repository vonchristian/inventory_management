class OutOfStockProductsController < ApplicationController
  def index
    @products = Product.out_of_stock
  end
end 
