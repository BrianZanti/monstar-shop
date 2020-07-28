require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can register and log in a new user' do
    visit '/'
    click_link 'Register'
    expect(current_path).to eq('/register')
    name = 'User McUserton'
    fill_in :user_name, with: name
    fill_in :user_address, with: "253 User ln."
    fill_in :user_city, with: "Userville"
    select "Utah", from: :user_state
    fill_in :user_zip, with: "83920"
    fill_in :user_email, with: "user.mcuserton@gmail.com"
    fill_in :user_password, with: "123password"
    fill_in :user_password_confirmation, with: "123password"

    click_button "Register"
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Logged In as #{name}")
    within '#flash' do
      expect(page).to have_content("Welcome #{name}! You are now registered and logged in.")
    end
  end
end