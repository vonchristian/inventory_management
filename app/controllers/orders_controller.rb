class OrdersController < ApplicationController
  def index
    if current_user.proprietor?
      @orders = Order.where(:pay_type => [:cash, :check]).order("id desc").all
    else
      @orders = current_user.sales
    end
  end
  def new
    @cart = current_cart
      if @cart.line_items.empty?
        redirect_to store_index_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
    @order.build_discount
  end
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    @order.employee = current_user
    respond_to do |format|
      if @order.save!
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to print_order_url(@order), notice:
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
    @line_items = @order.line_items
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PosReceiptPdf.new(@order, @line_items, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Invoice.pdf"
        pdf.print
      end
    end
  end

  def guest
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    @order.member = Member.find_by_first_name('Guest')
    @order.save
    redirect_to store_url, notice:
    'Thank you for your order.'
  end
  def print_invoice
    @order = Order.find(params[:id])
    @line_items = @order.line_items
      InvoiceNumber.new.generate_for(@order)
    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(@order, @line_items, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Invoice No.#{@order.invoice_number}.pdf"
        pdf.print
      end
    end
  end
  def print_official_receipt
    @order = Order.find(params[:id])
    @line_items = @order.line_items
    OfficialReceiptNumber.new.generate_for(@order)
    respond_to do |format|
      format.pdf do
        pdf = PosReceiptPdf.new(@order, @line_items, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Invoice No.#{@order.invoice_number}.pdf"
        pdf.print
      end
    end
  end

  def print
    @order = Order.find(params[:id])
    @line_items = @order.line_items
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PosReceiptPdf.new(order, order.line_items, view_context)
        pdf.print
      end
    end
  end


  private
  def order_params
    params.require(:order).permit(:user_id, :pay_type, :delivery_type, :date, :discounted, :cash_tendered, :change, discount_attributes: [:amount])
  end
end
