require 'rails_helper'

RSpec.describe 'Merchant Items index' do
  describe 'As a merchant employee' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:merchant_employee, merchant: @merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it 'has a link to the items index from the dashboard' do
      visit merchant_dashboard_path

      click_link 'My Items'

      expect(current_path).to eq('/merchant/items')
    end
  end
end
