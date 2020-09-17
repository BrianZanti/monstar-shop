require 'rails_helper'

RSpec.describe 'Admin Merchant Show Page' do
  before :each do
    @admin = create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    @merchant_1 = create(:disabled_merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    item = create(:item, merchant: @merchant_2)
    @order_1 = create(:order)
    @order_2 = create(:order)
    @order_3 = create(:shipped_order)

    create(:item_order, item: item, order: @order_1)
    create(:item_order, item: item, order: @order_2)
    create(:item_order, item: item, order: @order_3)
  end

  it 'The merchant index has links to the admin merchant show page' do
    visit '/merchants'

    click_link @merchant_2.name

    expect(current_path).to eq("/admin/merchants/#{@merchant_2.id}")
  end

  it 'shows everything a merchant would see' do
    visit "/admin/merchants/#{@merchant_2.id}"

    expect(page).to have_content(@merchant_2.name)
    expect(page).to have_content(@merchant_2.address)
    expect(page).to have_content(@merchant_2.city)
    expect(page).to have_content(@merchant_2.state)
    expect(page).to have_content(@merchant_2.zip)

    expect(page).to have_css("#order-#{@order_1.id}")
    expect(page).to have_css("#order-#{@order_2.id}")
    expect(page).to_not have_css("#order-#{@order_3.id}")
  end
end
