class Stock < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, :against => [:name, :serial_number]

  belongs_to :product
    has_many :line_items
    has_many :orders, through: :line_items
  after_commit :set_product_as_available
  delegate :set_product_as_available, to: :product
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'

  validates :purchase_price, :unit_price, :retail_price, :wholesale_price, presence: true, numericality: true
  before_save :set_date
  after_commit :create_entry, :set_name
  def in_stock

  end
  def sold
  end
  def sold_quantity
    quantity - line_items.all.sum(:quantity)
  end
  def out_of_stock?
    sold_quantity.zero? || quantity.zero?
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
    Accounting::Entry.create(date: self.date, )
  end
end
