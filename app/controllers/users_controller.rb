class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to settings_url, notice: 'Employee registered successfully.'
    else
      render :new
    end
  end
  def show
    @user = current_user
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :email, :password, :password_confirmation)
  end
end
