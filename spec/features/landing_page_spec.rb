require 'rails_helper'

RSpec.describe 'Landing Page' do
    before :each do 
        @user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123')
        @user2 = User.create(name: "User Two", email: "user2@test.com", password: 'password123')
        visit '/'
    end 

    it 'has a header' do
        expect(page).to have_content('Viewing Party Lite')
    end

    it 'has links/buttons that link to correct pages' do 
        click_button "Create New User"
        
        expect(current_path).to eq(register_path) 
        
        visit '/'

        click_link "Home"
        expect(current_path).to eq(root_path)

        visit '/'
        click_link "Login"
        expect(current_path).to eq(login_path)
    end 

    it 'does not list existing users to visitor' do 
        user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123')
        user2 = User.create(name: "User Two", email: "user2@test.com", password: 'password123')

        expect(page).to_not have_content('Existing Users:')
        expect(page).to_not have_css('.existing-users')
        expect(page).to_not have_content(user1.email)
        expect(page).to_not have_content(user2.email)

    end 

    # As a logged in user 
    # When I visit the landing page
    # I no longer see a link to Log In or Create an Account
    # But I see a link to Log Out.
    # When I click the link to Log Out
    # I'm taken to the landing page
    # And I can see that the Log Out link has changed back to a Log In link

    it 'doesnt have a link to log in or create and account if a user is already logged in' do
      click_link 'Login'

      fill_in :email, with:'user1@test.com'
      fill_in :password, with: 'password123'
      click_button 'Log In'
      visit '/'

      expect(page).to_not have_button('Create New User')
      expect(page).to_not have_link('Login')
    end

    it 'has logout button for users that are logged in' do
      click_link 'Login'

      fill_in :email, with:'user1@test.com'
      fill_in :password, with: 'password123'
      click_button 'Log In'
      visit '/'

      click_link "Log Out"
      expect(current_path).to eq '/'
      expect(page).to have_button('Create New User')
      expect(page).to have_link('Login')
    end

    # Task 3: User Story 1
    # As a visitor
    # When I visit the landing page
    # I do not see the section of the page that lists existing users

    it 'doesnt show existing users if youre not logged in' do
      expect(page).to_not have_content(@user1.email)
      expect(page).to_not have_content(@user2.email)
    end

    # As a registered user
    # When I visit the landing page
    # The list of existing users is no longer a link to their show pages
    # But just a list of email addresses

    it 'shows a list of existing users emails' do
      click_link 'Login'

      fill_in :email, with:'user1@test.com'
      fill_in :password, with: 'password123'
      click_button 'Log In'
      visit '/'

      expect(page).to have_content('Existing Users:')
        within('.existing-users') do
          expect(page).to have_content(@user1.email)
          expect(page).to have_content(@user2.email) 
        end
    end
end
