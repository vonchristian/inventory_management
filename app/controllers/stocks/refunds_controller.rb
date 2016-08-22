module Stocks
  class RefundsController < ApplicationController
    
    def new
      @stock = Stock.find(params[:stock_id])
      @refund = @stock.refunds.build
    end

    def create
      @product = Product.find(params[:product_id])
      @stock = @product.stocks.create(stock_params)
    end

    private
    def stock_params
      params.require(:stock).permit(:quantity, :date, :purchase_price, :serial_number, :expiry_date, :unit_price, :retail_price, :wholesale_price)
    end
  end
end
