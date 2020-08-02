require 'rails_helper'

RSpec.describe "Admin Dashboard" do
  before :each do
    @pending_orders = create_list(:order, 5)
    @packaged_orders = create_list(:packaged_order, 5)
    @shipped_orders = create_list(:shipped_order, 5)
    @cancelled_orders = create_list(:cancelled_order, 5)
    @all_orders = [@pending_orders, @packaged_orders, @shipped_orders, @cancelled_orders].flatten

    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "shows all orders in the system" do
    visit admin_dashboard_path

    @all_orders.each do |order|
      within "#order-#{order.id}" do
        expect(page).to have_content(order.id)
        expect(page).to have_content(order.user.name)
        expect(page).to have_content(order.created_at)
      end
    end
  end

  it "links to each users name to their admin show page" do
    visit admin_dashboard_path

    order = @all_orders.first
    within "#order-#{order.id}" do
      click_link(order.user.name)
    end

    expect(current_path).to eq(admin_user_path(order.user))
  end
end
