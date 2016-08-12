class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :employee
  after_commit :set_product_as_available
  delegate :set_product_as_available, to: :product
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'
  scope :created_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}

  validates :purchase_price, presence: true, numericality: true
  before_save :set_date
  after_commit :create_entry
  def self.entered_on(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : DateTime.parse(hash[:from_date])
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : DateTime.parse(hash[:to_date])
      where('date' => from_date..to_date)
    else
      all
    end
end
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
