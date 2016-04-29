require 'rails_helper'

RSpec.describe Cart, :type => :model do
  describe "associations" do
    it {is_expected.to have_many :line_items }
  end
end
