class Refund < ApplicationRecord
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'
  belongs_to :stock
  belongs_to :employee
  validates :date, :stock_id, :amount, :quantity, presence: true
  validates :amount, :quantity, numericality: true
  def self.total_amount
    all.sum(:amount)
  end
end
