require 'rails_helper'

RSpec.describe "Orders Index" do
  describe "As a regular, logged in user" do
    before :each do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      create(:order, user: user)
    end

    it 'has a link to the orders index from the provile page' do
      visit profile_path

      click_link 'My Orders'

      expect(current_path).to eq(profile_orders_path)
    end
  end


end
