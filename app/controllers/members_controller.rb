class MembersController < ApplicationController
  def index
    @member = Member.all
  end
  def new
    @member = Member.new
    @member.addresses.build
  end
  def create
    @member = Member.create(member_params)
    if @member.save
      redirect_to members_url, notice: "Member saved successfully."
    else
      render :new
    end
  end

  def show
    @member = Member.find(params[:id])
  end

  private
  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation, :mobile, addresses_attributes:[:house_number, :street, :barangay, :municipality, :province ])
  end
end
