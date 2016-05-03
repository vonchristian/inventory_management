class ProductsController < ApplicationController
  def index
    if params[:name].present?
      @products = Product.search_by_name(params[:name])
    else
      @products = Product.all.order(:name)
    end
  end
  def new
    @product = Product.new
    @product.stocks.build
  end
  def create
    @product = Product.create(product_params)
    if @product.save
      redirect_to @product, notice: "Product saved successfully."
    else
      render :new
    end
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
    params.require(:product).permit(:name, :price, :unit, stocks_attributes:[:quantity, :date])
  end
end
