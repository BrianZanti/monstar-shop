
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_link("Cart: 0")
      end
    end

    it "Has a nav bar with links to all pages" do
      visit '/'

      within '#navigation' do
        expect(page).to have_link('Monstar Shop')
        expect(page).to have_link('Items')
        expect(page).to have_link('Merchants')
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to have_link('Cart: 0')
      end
    end
  end

  describe 'as a Logged in User' do
    before :each do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "shows a message that the user is logged in" do
      visit '/'

      within '#navigation' do
        expect(page).to have_content("Logged In as #{@user.name}")
      end
    end

    it "has all visitor links, plus a profile and logout, minus login and register" do
      visit '/'

      within '#navigation' do
        expect(page).to have_link('Monstar Shop')
        expect(page).to have_link('Items')
        expect(page).to have_link('Merchants')
        expect(page).to have_link('Log Out')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Profile')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')
      end
    end
  end
end
