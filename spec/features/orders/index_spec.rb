require 'rails_helper'

RSpec.describe "Orders Index" do
  describe "As a regular, logged in user" do
    before :each do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      @order_1 = create(:order, user: user)
      @order_2 = create(:order, user: user, status: :packaged)
      @order_3 = create(:order, user: user)
    end

    it 'has a link to the orders index from the provile page' do
      visit profile_path

      click_link 'My Orders'

      expect(current_path).to eq(profile_orders_path)
    end

    it 'shows each order and its info' do
      # As a registered user
      # When I visit my Profile Orders page, "/profile/orders"
      # I see every order I've made, which includes the following information:
      # - the ID of the order, which is a link to the order show page
      # - the date the order was made
      # - the date the order was last updated
      # - the current status of the order
      # - the total quantity of items in the order
      # - the grand total of all items for that order
      visit profile_orders_path

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("Order ##{@order_1.id}")
        expect(page).to have_content("Created on #{@order_1.created_at}")
        expect(page).to have_content("Last updated on #{@order_1.updated_at}")
        expect(page).to have_content("status: #{@order_1.status}")
        expect(page).to have_content("Number of items: #{@order_1.total_quantity}")
        expect(page).to have_content("Grand Total: #{@order_1.grandtotal}")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content("Order ##{@order_2.id}")
        expect(page).to have_content("Created on #{@order_2.created_at}")
        expect(page).to have_content("Last updated on #{@order_2.updated_at}")
        expect(page).to have_content("status: #{@order_2.status}")
        expect(page).to have_content("Number of items: #{@order_2.total_quantity}")
        expect(page).to have_content("Grand Total: #{@order_2.grandtotal}")
      end

      within "#order-#{@order_3.id}" do
        expect(page).to have_content("Order ##{@order_3.id}")
        expect(page).to have_content("Created on #{@order_3.created_at}")
        expect(page).to have_content("Last updated on #{@order_3.updated_at}")
        expect(page).to have_content("status: #{@order_3.status}")
        expect(page).to have_content("Number of items: #{@order_3.total_quantity}")
        expect(page).to have_content("Grand Total: #{@order_3.grandtotal}")
      end
    end

    it 'each order id is a link to its show page' do
      visit profile_orders_path

      click_link "Order ##{@order_1.id}"

      expect(current_path).to eq(profile_order_path(@order_1))

      visit profile_orders_path

      click_link "Order ##{@order_2.id}"

      expect(current_path).to eq(profile_order_path(@order_2))
    end
  end
end
