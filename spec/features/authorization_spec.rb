require 'rails_helper'

RSpec.describe "Authorization" do
  describe "as a Visitor" do
    it 'cannot visit the merchant namespace' do
      visit '/merchant'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the admin namespace' do
      visit '/admin'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the profile page' do
      visit '/profile'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end
  end

  describe "as a User" do
    before :each do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'cannot visit the merchant namespace' do
      visit '/merchant'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the admin namespace' do
      visit '/admin'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end
  end

  describe "as a Merchant Employee" do
    before :each do
      @user = create(:merchant_employee)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'cannot visit the admin namespace' do
      visit '/admin'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end
  end

  describe "as an Admin" do
    before :each do
      @user = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'cannot visit the merchant namespace' do
      visit '/merchant'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the cart page' do
      visit '/cart'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end
  end
end
