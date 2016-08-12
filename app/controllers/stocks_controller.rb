class StocksController < ApplicationController
  def index
    @stocks = Stock.all.order('date DESC')
    authorize @stocks
  end
  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.create(stock_params)
    if @stock.save
      redirect_to stocks_url, notice: "New stock saved successfully."
    else
      render :new
    end
  end

  private
  def stock_params
    params.require(:stock).permit(:product_id, :quantity, :date, :purchase_price, :serial_number, :expiry_date)
  end
end
