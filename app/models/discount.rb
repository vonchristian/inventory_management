class Discount < ApplicationRecord
  enum discount_type: [:amount, :percent]
end
