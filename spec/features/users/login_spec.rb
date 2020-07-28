require 'rails_helper'

RSpec.describe 'User Login' do
  describe 'as a user' do
    it 'can login with valid info' do
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
end
