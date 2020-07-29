require 'rails_helper'

RSpec.describe 'User Edit' do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe 'editing profile' do
    it "has a link from profile to the edit form that is prepopulated" do
      visit profile_path

      click_link 'Edit Profile'

      expect(current_path).to eq(user_edit_path)
      expect(find('#user_name').value).to eq(@user.name)
      expect(find('#user_address').value).to eq(@user.address)
      expect(find('#user_city').value).to eq(@user.city)
      expect(find('#user_state').value).to eq(@user.state)
      expect(find('#user_zip').value).to eq(@user.zip)
      expect(find('#user_email').value).to eq(@user.email)
    end

    it 'can edit profile info' do
      visit user_edit_path

      new_name = "User McUserton"
      new_address = "123 user ln."
      new_city = "Usersville"
      new_state = "Utah"
      new_zip = "65401"
      new_email = "user.mcuserton@gmail.com"

      fill_in :user_name, with: new_name
      fill_in :user_address, with: new_address
      fill_in :user_city, with: new_city
      select new_state, from: :user_state
      fill_in :user_zip, with: new_zip
      fill_in :user_email, with: new_email

      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your profile has been updated.")

      expect(page).to have_content(new_name)
      expect(page).to have_content(new_address)
      expect(page).to have_content(new_city)
      expect(page).to have_content(new_state)
      expect(page).to have_content(new_zip)
      expect(page).to have_content(new_email)
    end

    it 'shows errors if blank info is submitted' do
      visit user_edit_path

      fill_in :user_name, with: ''
      fill_in :user_address, with: ''
      fill_in :user_city, with: ''
      select '', from: :user_state
      fill_in :user_zip, with: ''
      fill_in :user_email, with: ''

      click_button 'Update Profile'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Email can't be blank")
    end

    it 'shows error if email is not unique' do
      other_user = create(:user)
      visit user_edit_path

      fill_in :user_email, with: other_user.email
      click_button 'Update Profile'
      expect(page).to have_content("Email has already been taken")
    end
  end

  describe 'editing password' do
    it 'can edit their password' do
      new_password = 'new password'

      visit profile_path
      click_link "Edit Password"
      fill_in :password, with: new_password
      fill_in :password_confirmation, with: 'new password'
      click_button 'Update Password'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Your password has been updated.')

      click_link('Log Out')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_call_original
      visit login_path
      fill_in :email, with: @user.email
      fill_in :password, with: new_password
      click_button 'Login'
      expect(page).to have_content('you are now logged in.')
    end

    it 'does not change password if it doesnt match the confirmation' do
      visit profile_path
      click_link "Edit Password"
      fill_in :password, with: 'new password'
      fill_in :password_confirmation, with: 'different password'
      click_button 'Update Password'
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
