class MembersController < ApplicationController
  def index
    @member = Member.all
  end
  def new
    @member = Member.new
    @member.addresses.build
  end
  def create
    @members = Member.all
    @member = Member.create(member_params)
  end

  def show
    @member = Member.find(params[:id])
  end

  private
  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :mobile, addresses_attributes:[:house_number, :street, :barangay, :municipality, :province ])
  end
end
