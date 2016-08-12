class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  def after_sign_in_path_for(current_user)
    if current_user.is_a?(Employee) && current_user.proprietor?
      owner_dashboard_index_url
    elsif current_user.is_a?(Employee) && current_user.stock_custodian?
      stock_custodian_dashboard_url
    elsif current_user.is_a?(Employee) && current_user.bookkeeper?
      accounting_dashboard_index_url
    elsif current_user.is_a?(Employee) && current_user.cashier?
      store_index_url
    elsif current_user.is_a?(Employee) && current_user.accountant?
      accounting_index_url
    end
  end
  private
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    def permission_denied
    redirect_to  after_sign_in_path_for(current_user), alert: "We're sorry but you are not allowed to access this page or feature."
  end
end
