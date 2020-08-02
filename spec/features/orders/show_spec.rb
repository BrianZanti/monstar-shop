require 'rails_helper'

RSpec.describe "Order show page" do
  describe 'as a regular, logged in user' do
    before :each do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      @order = create(:order, user: user)
      create_list(:item_order, 3, order: @order)
      create(:item_order, order: @order, fulfilled?: true)
    end

    it 'shows all order and item order details' do
      visit profile_order_path(@order)

      expect(page).to have_content("Order ##{@order.id}")
      expect(page).to have_content("Created on #{@order.created_at}")
      expect(page).to have_content("Last updated on #{@order.updated_at}")
      expect(page).to have_content("status: #{@order.status}")
      expect(page).to have_content("Number of items: #{@order.total_quantity}")
      expect(page).to have_content("Grand Total: #{@order.grandtotal}")

      @order.item_orders.each do |item_order|
        within "#item-#{item_order.item_id}" do
          expect(page).to have_content(item_order.item.name)
          expect(page).to have_content(item_order.item.description)
          within '.quantity' do
            expect(page).to have_content(item_order.quantity)
          end
          within '.price' do
            expect(page).to have_content(number_to_currency(item_order.convert_price))
          end
          within '.subtotal' do
            expect(page).to have_content(number_to_currency(item_order.subtotal))
          end
          expect(page).to have_xpath("//img[@src='#{item_order.item.image}']")
        end
      end
    end

    it 'can cancel an order' do
      visit profile_order_path(@order)

      click_button 'Cancel Order'

      expect(current_path).to eq(profile_order_path(@order))

      expect(page).to have_content("status: cancelled")

      @order.item_orders.each do |item_order|
        expect(item_order.fulfilled?).to be(false)
      end
    end

    it 'cannot cancel the order if it is shipped' do
      order = create(:shipped_order)

      visit profile_order_path(order)

      expect(page).to_not have_button('Cancel Order')
    end
  end
end
