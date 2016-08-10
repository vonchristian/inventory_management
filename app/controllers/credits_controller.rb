class CreditsController < ApplicationController
  def index
    @orders = Order.credit
  end
end
