require 'rails_helper'

feature 'Creating a product', type: :feature do
  #  before (:each) do
  #    user = FactoryGirl.create(:user)
  #    login_as(user, :scope => :user)
  #  end

  scenario 'with valid information' do
    visit products_path
    click_link "New Product"
    fill_in "Name", with: "4x5 Lumber"
    fill_in "Price", with: 10
    click_button "Save Product"

    expect(page).to have_content("saved successfully.")
    expect(page).to have_content("4x5 Lumber")
  end
  end
