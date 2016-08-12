class Stock < ApplicationRecord
  belongs_to :product
  after_commit :set_product_as_available
  delegate :set_product_as_available, to: :product
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'

  validates :purchase_price, presence: true, numericality: true
  before_save :set_date
  after_commit :create_entry
  private
  def set_date
    if self.date.nil?
      self.date = Time.zone.now
    end
  end
  def create_entry
    Accounting::Entry.create(date: self.date, )
  end
end
