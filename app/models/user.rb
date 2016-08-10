class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses
  has_many :orders
  accepts_nested_attributes_for :addresses

  def full_name
    "#{first_name} #{last_name}"
  end
  def address
    addresses.first.details
  end
end
