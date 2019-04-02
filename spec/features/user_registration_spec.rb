require 'rails_helper'

RSpec.describe 'Registration page' do
  before :each do
    @user_info = attributes_for(:user)
  end
  context 'as a not-logged-on-user' do
    it 'directs to the register page when the register link is clicked' do
      visit root_path

      click_link "Register"
      expect(current_path).to eq(register_path)
    end
    it 'registration page has fields for all information; can be submitted' do
      visit register_path

      fill_in "Name", with: @user_info[:name]
      fill_in "Street Address", with: @user_info[:street_address]
      fill_in "City", with: @user_info[:city]
      fill_in "State", with: @user_info[:state]
      fill_in "Zip Code", with: @user_info[:zip_code]
      fill_in "E-Mail", with: @user_info[:email]
      fill_in "Password", with: @user_info[:password]
      fill_in "Confirm Password", with: @user_info[:password]

      click_button "Register"
    end

    it 'registration page if not fully filled in redirects to register page' do
      visit register_path

      fill_in "Name", with: @user_info[:name]
      fill_in "State", with: @user_info[:state]
      fill_in "Zip Code", with: @user_info[:zip_code]
      fill_in "E-Mail", with: @user_info[:email]
      fill_in "Password", with: @user_info[:password]
      fill_in "Confirm Password", with: @user_info[:password]

      click_button "Register"

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Please fill in all fields.")
    end

    it 'registration will not allow you to use an email in the database' do
      user_2 = create(:user)

      visit register_path

      fill_in "Name", with: @user_info[:name]
      fill_in "Street Address", with: @user_info[:street_address]
      fill_in "City", with: @user_info[:city]
      fill_in "State", with: @user_info[:state]
      fill_in "Zip Code", with: @user_info[:zip_code]
      fill_in "E-Mail", with: user_2.email
      fill_in "Password", with: @user_info[:password]
      fill_in "Confirm Password", with: @user_info[:password]

      click_button "Register"


      # All previous data still filled in testing
      expect(current_path).to eq(register_path)
      expect(page).to have_content("E-Mail already in use.")
      
      expect(page).to have_content(@user_info[:name])
      expect(page).to have_content(@user_info[:street_address])
      expect(page).to have_content(@user_info[:city])
      expect(page).to have_content(@user_info[:state])
      expect(page).to have_content(@user_info[:zip_code])
      expect(page).to have_content(@user_info[:password])

    end
  end

  context 'as a logged-in-user' do
    it 'does not allow you to the registration page' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit register_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are already Registered")

    end
  end
end

RSpec.describe 'Registration page' do
  before :each do
    @user_info = attributes_for(:user)

    fill_in "Name", with: @user_info[:name]
    fill_in "Street Address", with: @user_info[:street_address]
    fill_in "City", with: @user_info[:city]
    fill_in "State", with: @user_info[:state]
    fill_in "Zip Code", with: @user_info[:zip_code]
    fill_in "E-Mail", with: @user_info[:email]
    fill_in "Password", with: @user_info[:password]
    fill_in "Confirm Password", with: @user_info[:password]

    click_button "Register"

  end
  context 'as a not-logged-in-user having filled out the registration' do
    it 'a new user has been created with the correct information' do
      user = User.last

      expect(user.name).to eq(@user_info[:name])
      expect(user.street_address).to eq(@user_info[:street_address])
      expect(user.city).to eq(@user_info[:city])
      expect(user.state).to eq(@user_info[:state])
      expect(user.zip_code).to eq(@user_info[:zip_code])
      expect(user.email).to eq(@user_info[:email])
      # expect(user.password).to eq(@user_info[:password])  SHOULD USE AUTHENTICATE METHOD?

    end

    it 'you should be on the user profile page with a flash message about registration and logging in' do
      expect(current_path).to eq(profile_path(User.last))
      expect(page).to have_content("You are now registered and logged in")
    end

  end
end