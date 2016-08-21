class Member < User
  enum role: [:customer]
  def to_s
    full_name
  end
end
