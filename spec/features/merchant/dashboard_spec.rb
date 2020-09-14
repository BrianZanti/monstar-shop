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

    describe 'when my merchant has pending orders with unfulfilled items' do
      before :each do
        items = create_list(:item, 3, merchant: @merchant)
        @order_1 = create(:order)
        @order_2 = create(:order)
        @order_3 = create(:order)
        @order_4 = create(:order)
        @order_5 = create(:shipped_order)
        @order_6 = create(:cancelled_order)
        @order_7 = create(:packaged_order)
        @order_8 = create(:order)
        create(:item_order, item: items.first, order: @order_1)
        create_list(:item_order, 2, order: @order_1)
        create_list(:item_order, 2, order: @order_2)
        create(:item_order, item: items.second, order: @order_3)
        create(:item_order, order: @order_4)
        create(:item_order, item: items.third, order: @order_5)
        create(:item_order, item: items.first, order: @order_6)
        create(:item_order, item: items.second, order: @order_7)
        create(:fulfilled_item_order, item: items.first, order: @order_8)
      end

      it 'shows all pending orders' do
        visit merchant_dashboard_path

        @merchant.pending_orders.each do |order|
          within "#order-#{order.id}" do
            expect(page).to have_link("Order ##{order.id}", href: merchant_order_path(order))
            expect(page).to have_content("Created at: #{order.created_at}")
            expect(page).to have_content("Quantity of items on this order: #{@merchant.quantity_ordered(order)}")
            expect(page).to have_content("Value of items on this order: #{@merchant.revenue_from(order)}")
          end
        end

        expect(page).to_not have_css("#order-#{@order_5.id}")
        expect(page).to_not have_css("#order-#{@order_6.id}")
        expect(page).to_not have_css("#order-#{@order_7.id}")
      end
    end

    describe 'when my merchant has no pending orders' do
      it 'shows a message' do
        visit merchant_dashboard_path

        expect(page).to have_content('There are no pending orders')
      end
    end
  end

end
