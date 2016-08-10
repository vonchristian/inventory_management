class Address < ApplicationRecord
  belongs_to :user

  def details
    "#{street} #{barangay}"
  end
end
