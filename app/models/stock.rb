class Stock < ApplicationRecord
  belongs_to :product
  after_commit :set_product_as_available
  delegate :set_product_as_available, to: :product
end
