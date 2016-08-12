class OrdersController < ApplicationController
  def index
    if current_user.proprietor?
      @orders = Order.all.order(:id).reverse
    else
      @orders = current_user.sales
    end
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
    @order.employee = current_user
    respond_to do |format|
      if @order.save!
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to store_url, notice:
        'Thank you for your order.' }
        format.json { render json: @order, status: :created,
        location: @order }
        #print_receipt
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

  def guest
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    @order.member = Member.find_by_first_name('Guest')
    @order.save
    redirect_to store_url, notice:
    'Thank you for your order.'
  end

  private
  def order_params
    params.require(:order).permit(:user_id, :pay_type, :delivery_type, :date)
  end
end
