class Order < ApplicationRecord
  acts_as_paranoid
  include PgSearch
  pg_search_scope :search_by_name, :against => [:reference_number]

  has_one :official_receipt_number
  has_one :invoice_number
  belongs_to :employee, foreign_key: 'employee_id'
  belongs_to :member, foreign_key: 'user_id'
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'
  enum pay_type:[:cash, :credit, :check]
  enum order_type: [:retail, :wholesale]
  enum delivery_type: [:pick_up, :deliver, :to_go]
  has_many :line_items, dependent: :destroy
  has_many :credit_payments
  has_one :discount
  belongs_to :tax
  before_save :set_date, :set_user
  after_commit :create_entry, :set_line_items_payment_type

  validates :user_id, presence: true
  accepts_nested_attributes_for :discount
  scope :created_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
  def name
    customer_name
  end
  def customer_name
    member.try(:full_name)
  end
  def vatable_amount
    0
  end
  def vat_percentage
    12
  end
  def machine_accreditation
    ""
  end
  def total_discount
    if discount.present?
      discount.amount
    else
      0
    end
  end
  def reference_number
    "#{id.to_s.rjust(8, '0')}"
  end
  def self.total_amount
    all.map{|a| a.total_amount }.sum
  end
  def tax_rate
    if business.non_vat_registered?
      0.03
    elsif business.vat_registered?
      0.12
    end
  end
  def total_amount
    line_items.sum(:total_cost)
  end
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  private
  def create_entry
    if self.cash?
    Accounting::Entry.create(commercial_document_id: self.id, commercial_document_type: self.class, date: self.date, description: "Payment for order ##{self.reference_number}", debit_amounts_attributes: [amount: self.total_amount, account: "Cash on Hand"], credit_amounts_attributes:[amount: self.total_amount, account: 'Sales'],  employee_id: self.employee_id)
  elsif self.credit?
    Accounting::Entry.create(commercial_document_id: self.id, commercial_document_type: self.class, date: self.date, description: "Credit order ##{self.reference_number}", debit_amounts_attributes: [amount: self.total_amount, account: "Accounts Receivables Trade - Current"], credit_amounts_attributes:[amount: self.total_amount, account: 'Sales'],  employee_id: self.employee_id)
  end
  end
  def set_date
    self.date = Time.zone.now
  end
  def set_user
    if user_id.nil?
      user_id = User.find_by_first_name('Guest').id
    end
  end
  def set_line_items_payment_type
    if self.credit?
      line_items.each do |line_item|
        line_item.credit!
      end
    elsif self.cash?
      line_items.each do |line_item|
        line_item.cash!
      end
    end
  end

end
