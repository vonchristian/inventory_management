class Member < User
scope :by_total_credit, -> {with_credits.to_a.sort_by(&:total_credit).reverse }
  enum role: [:customer]
  def to_s
    full_name
  end
  def self.with_credits
    self.joins(:line_items).merge(LineItem.credit)
  end
  def total_credit
    self.line_items.credit.sum(:total_cost)
  end
  def first_credit_created_at
    if line_items.credit.present?
      line_items.first.created_at.strftime("%B %e, %Y")
    else
      ''
    end
  end
end
