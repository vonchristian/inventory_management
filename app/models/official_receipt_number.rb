class OfficialReceiptNumber < ApplicationRecord
  belongs_to :order

  def self.generate_for(order)
    if order.official_receipt_number.blank?
    OfficialReceiptNumber.create(order_id: order.id)
  else
    return false
  end
  end
  def to_s
  "#{self.id.to_s.rjust(8, '0')}"
end
end
