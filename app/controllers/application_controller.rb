class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  private
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    def permission_denied
    redirect_to user_path(current_user), alert: "We're sorry but you are not allowed to access this page or feature."
  end
end
