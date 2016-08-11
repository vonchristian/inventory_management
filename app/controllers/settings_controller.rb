class SettingsController < ApplicationController
  def index
    @business = Business.last
  end
end
