require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'as a logged in merchant employee' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:merchant_employee, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end
    it 'shows the name and address of the merchant' do
      visit merchant_dashboard_path

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)
    end
  end

end
