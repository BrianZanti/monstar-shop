require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @item_1 = create(:item)
      @item_2 = create(:item)
      @inactive_item_1 = create(:inactive_item)
      @inactive_item_2 = create(:inactive_item)
    end

    it "all items or merchant names are links" do
      visit '/items'

      click_link @item_1.name
      expect(current_path).to eq(item_path(@item_1))

      visit '/items'

      click_link @item_1.merchant.name
      expect(current_path).to eq(merchant_path(@item_1.merchant))

      visit '/items'

      click_link @item_2.name
      expect(current_path).to eq(item_path(@item_2))

      visit '/items'

      click_link @item_2.merchant.name
      expect(current_path).to eq(merchant_path(@item_2.merchant))
    end

    it 'all item images are links' do
      visit '/items'
      within "#item-#{@item_2.id}" do
        find('.item-image').click
        expect(current_path).to eq(item_path(@item_2))
      end

      visit '/items'
      within "#item-#{@item_1.id}" do
        find('.item-image').click
        expect(current_path).to eq(item_path(@item_1))
      end
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content("Price: #{number_to_currency(@item_1.convert_price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_1.inventory}")
        expect(page).to have_link(@item_1.merchant.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_content("Price: #{number_to_currency(@item_2.convert_price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_2.inventory}")
        expect(page).to have_link(@item_2.merchant.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
      end
    end

    it 'does not show disabled items' do
      visit '/items'

      expect(page).to_not have_css("#item-#{@inactive_item_1.id}")
      expect(page).to_not have_css("#item-#{@inactive_item_2.id}")
    end

    it 'has item statistics' do

    end
  end
end
