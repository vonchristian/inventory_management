class Member < User
scope :by_total_credit, -> {with_credits.to_a.sort_by(&:total_credit).reverse }
  enum role: [:customer]
  def to_s
    full_name
  end
  def self.with_credits
    self.joins(:line_items).merge(LineItem.credit)
  end
  def self.total_credit
    all.map{|a| a.total_credit }.sum
  end
  def total_credit
    self.line_items.credit.sum(:total_cost)
  end
  def first_credit_created_at
    if line_items.credit.present?
      line_items.first.created_at.strftime("%B %e, %Y")
    end
  end
  def has_credit?
    line_items.credit.present?
  end
  def set_credits_to_paid
    line_items.credit.each do |line_item|
      line_item.cash!
    end
  end
end
