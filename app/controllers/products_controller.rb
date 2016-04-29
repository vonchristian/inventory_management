class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  def new
    @product = Product.new
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

  private
  def product_params
    params.require(:product).permit(:name, :price)
  end
end
