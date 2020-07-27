
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
end
