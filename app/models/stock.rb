class Stock < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, :against => [:name, :serial_number]
  enum stock_type:[:purchased, :returned]
  belongs_to :product
  belongs_to :employee
    has_many :line_items
    has_many :orders, through: :line_items
    has_many :refunds
  after_commit :set_product_as_available
  delegate :set_product_as_available, to: :product
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'
  scope :created_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}

  validates :purchase_price, :unit_price, :retail_price, :wholesale_price, presence: true, numericality: true
  before_save :set_date
  after_commit :create_entry, :set_name
  def self.total_cost_of_purchase
    all.sum(:purchase_price)
  end

  def self.entered_on(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : DateTime.parse(hash[:from_date])
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : DateTime.parse(hash[:to_date])
      where('date' => from_date..to_date)
    else
      all
    end
  end

  def in_stock
    self.quantity - sold
  end

  def sold
    line_items.sum(:quantity)
  end


  def out_of_stock?
    in_stock.zero? || in_stock.negative?
  end

  private
  def set_date
    if self.date.nil?
      self.date = Time.zone.now
    end
  end
  def set_name
    self.name = self.product.name
  end
  def create_entry
    Accounting::Entry.create(date: self.date )
  end
end
