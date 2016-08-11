class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses
  has_many :orders
  has_many :line_items, through: :orders
  accepts_nested_attributes_for :addresses
  enum role: [:sales_clerk, :stock_custodian]

  def full_name
    "#{first_name} #{last_name}"
  end
  def address
    addresses.first.details
  end
end
