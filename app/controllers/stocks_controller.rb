class StocksController < ApplicationController
  def index
    if params[:name].present?
      @stocks = Stock.search_by_name(params[:name])
    else
      @stocks = Stock.includes(:product).all.order('date DESC')
      authorize @stocks
    end
  end
  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.create(stock_params)
    @stock.employee = current_user
    if @stock.save
      @stock.create_entry
      redirect_to stocks_url, notice: "New stock saved successfully."
    else
      render :new
    end
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def scope_to_date
    @stocks = Stock.created_between(params[:from_date], params[:to_date])
    @from_date = params[:from_date] ? Time.parse(params[:from_date]) : Time.now.beginning_of_day
    @to_date = params[:to_date] ? Time.parse(params[:to_date]) : Time.now.end_of_day
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StocksPdf.new(@stocks, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Purchases Report.pdf"
      end
    end
  end

  private
  def stock_params
    params.require(:stock).permit(:product_id, :quantity, :date, :purchase_price, :serial_number, :expiry_date, :unit_price, :retail_price, :wholesale_price)
  end
end
