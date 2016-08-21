class InvoiceNumber < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, :against => [:number]
  belongs_to :order
  def generate_for(order)
    if order.invoice_number.blank?
      InvoiceNumber.create!(order_id: order.id, date: Time.zone.now, number: number)
    else
      return false
    end
  end
  def number
    "#{self.id.to_s.rjust(8, '0')}"
  end
end
