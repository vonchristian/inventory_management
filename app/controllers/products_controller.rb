class ProductsController < ApplicationController
  def index
    if params[:name].present?
      @products = Product.search_by_name(params[:name])
    else
      @products = Product.all.order(:name)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = ProductsPdf.new(@products, view_context)
                send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Products Report.pdf"
        end
      end
    end
  end
  def new
    @product = Product.new
    @product.stocks.build
  end
  def create
    @products = Product.all
    @product = Product.create(product_params)
    @product.check_stock_status
  end
  def show
    begin
    @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to products_url, alert: 'The inventory you were looking for could not be found.'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cart }
      end
    end
  end

  def edit
    @product = Product.find(params[:id ])
  end

  def update
    @product = Product.find(params[:id])
    @product.update(product_params)
    if @product.save
      redirect_to @product, notice: "Product updated successfully."
    else
      render :edit
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :wholesale_price, :unit, :stock_alert_count, :bar_code, stocks_attributes:[:quantity, :date])
  end
end
