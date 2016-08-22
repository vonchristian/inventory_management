class MembersController < ApplicationController
  def index
    if params[:name].present?
      @members = User.search_by_name(params[:name])
    else
      @members = Member.all
    end
  end
  def new
    @member = Member.new
    @member.addresses.build
  end
  def create
    @member = Member.all
    @member = Member.create(member_params)
  end

  def show
    @member = Member.find(params[:id])
  end

  private
  def member_params
    params.require(:member).permit(:role, :first_name, :last_name, :email, :password, :password_confirmation, :mobile, addresses_attributes:[:house_number, :street, :barangay, :municipality, :province ])
  end
end
