require 'rails_helper'

RSpec.describe 'User Dashboard' do
  # As a visitor
  # When I visit the landing page
  # And then try to visit '/dashboard'
  # I remain on the landing page
  # And I see a message telling me that I must be logged in or registered to access my dashboard
  it 'does not allow visitors to view page' do
    user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123')
    visit root_path
    visit "/users/#{user1.id}"
    expect(current_path).to eq root_path
    expect(page).to have_content('You must be a registered user to access this page')
  end
end