class OrdersController < ApplicationController
  def index
    @orders = Order.all.order(:created_at)
  end
  def new
    @cart = current_cart
      if @cart.line_items.empty?
        redirect_to store_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    respond_to do |format|
      if @order.save!
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to store_url, notice:
        'Thank you for your order.' }
        format.json { render json: @order, status: :created,
        location: @order }
      else
        @cart = current_cart
        format.html { render action: "new" }
        format.json { render json: @order.errors,
        status: :unprocessable_entity }
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:user_id, :pay_type, :delivery_type)
  end
end
