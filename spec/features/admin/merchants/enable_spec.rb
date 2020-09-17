require 'rails_helper'

RSpec.describe 'Admin Merchants Index' do
  describe 'as an Admin' do
    before :each do
      @admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @merchant_1 = create(:disabled_merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      @item = create(:item, merchant: @merchant_2)
      @order_1 = create(:order)
      @order_2 = create(:order)
      @order_3 = create(:shipped_order)

      create(:item_order, item: @item, order: @order_1)
      create(:item_order, item: @item, order: @order_2)
      create(:item_order, item: @item, order: @order_3)
    end

    it 'has a button to disable merchants' do
      visit '/admin/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_button "disable"
      end

      expect(current_path).to eq('/admin/merchants')
      expect(page).to have_content("#{@merchant_2.name} is now disabled.")

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_button('enable')
      end
    end

    it 'when a merchant is disabled, their items are deactivated' do
      visit '/items'

      expect(page).to have_css("#item-#{@item.id}")

      visit '/admin/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_button "disable"
      end

      visit '/items'

      expect(page).to_not have_css("#item-#{@item.id}")
    end

    it 'has a button to enable merchants' do
      visit '/admin/merchants'

      within "#merchant-#{@merchant_1.id}" do
        click_button "enable"
      end

      expect(current_path).to eq('/admin/merchants')
      expect(page).to have_content("#{@merchant_1.name} is now enabled.")

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_button('disable')
      end
    end

    it 'when a merchant is enabled, all their items are enabled' do
      @merchant_2.toggle_enabled
      
      visit '/items'

      expect(page).to_not have_css("#item-#{@item.id}")

      visit '/admin/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_button "enable"
      end

      visit '/items'

      expect(page).to have_css("#item-#{@item.id}")
    end
  end
end
