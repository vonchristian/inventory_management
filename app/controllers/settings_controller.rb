class SettingsController < ApplicationController
  def index
   @business = Business.find(params[:business_id])
  end
end
