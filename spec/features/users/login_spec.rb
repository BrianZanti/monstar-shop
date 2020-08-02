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

    it 'redirects if the user is already logged in' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You are already logged in.")
    end
  end

  describe 'as an Admin' do
    it 'can login with valid info and redirect to the Admin Dashboard' do
      user = create(:admin)

      visit '/'
      click_link 'Login'

      expect(current_path).to eq(login_path)

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Login'

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("Welcome #{user.name}, you are now logged in.")
    end

    it 'redirects if the admin is already logged in' do
      user = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("You are already logged in.")
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

      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content("Welcome #{user.name}, you are now logged in.")
    end

    it 'redirects if the merchant is already logged in' do
      user = create(:merchant_employee)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path

      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content("You are already logged in.")
    end
  end

  it 'cannot log in with incorrect password' do
    user = create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: 'incorrect'
    click_button 'Login'

    expect(page).to have_css('#login-form')
    expect(page).to have_content("Invalid email or password.")
  end

  it 'cannot log in with an unknown email' do
    visit login_path

    fill_in :email, with: 'unknown@gmail.com'
    fill_in :password, with: 'password'
    click_button 'Login'

    expect(page).to have_css('#login-form')
    expect(page).to have_content("Invalid email or password.")
  end

  it 'users can log out' do
    user = create(:user)
    item = create(:item)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit item_path(item)
    click_button 'Add To Cart'
    click_link 'Log Out'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('You are now logged out.')
    expect(page).to have_content('Cart: 0')
  end
end
