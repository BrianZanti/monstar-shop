require 'rails_helper'

RSpec.describe 'User Login' do
  describe 'as a user' do
    it 'can login with valid info and redirect to profile page' do
      user = create(:user)

      visit '/'
      click_link 'Login'

      expect(current_path).to eq(login_path)

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Login'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Welcome #{user.name}, you are now logged in.")
    end
  end

  describe 'as an Admin' do
    it 'can login with valid info and redirect to the Merchant Dashboard' do
      user = create(:admin)

      visit '/'
      click_link 'Login'

      expect(current_path).to eq(login_path)

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Login'

      expect(current_path).to eq(admin_path)
      expect(page).to have_content("Welcome #{user.name}, you are now logged in.")
    end
  end

  describe 'as a Merchant Employee' do
    it 'can login with valid info and redirect to the Merchant Dashboard' do
      user = create(:merchant_employee)

      visit '/'
      click_link 'Login'

      expect(current_path).to eq(login_path)

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Login'

      expect(current_path).to eq(merchant_path)
      expect(page).to have_content("Welcome #{user.name}, you are now logged in.")
    end
  end
end
