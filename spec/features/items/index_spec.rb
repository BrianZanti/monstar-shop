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

      within "#item-#{@item_1.id}" do
        click_link @item_1.name
        expect(current_path).to eq(item_path(@item_1))
      end

      visit '/items'
      within "#item-#{@item_1.id}" do
        click_link @item_1.merchant.name
        expect(current_path).to eq(merchant_path(@item_1.merchant))
      end

      visit '/items'
      within "#item-#{@item_2.id}" do
        click_link @item_2.name
        expect(current_path).to eq(item_path(@item_2))
      end

      visit '/items'
      within "#item-#{@item_2.id}" do
        click_link @item_2.merchant.name
        expect(current_path).to eq(merchant_path(@item_2.merchant))
      end
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
  end

  describe 'statistics' do
    it 'shows the top and bottom 5 most popular items' do
      items = create_list(:item, 8)

      create_list(:item_order, 2, item: items[0])
      create_list(:item_order, 4, item: items[1])
      create_list(:item_order, 8, item: items[2])
      create_list(:item_order, 10, item: items[3])
      create_list(:item_order, 1, item: items[4])
      create_list(:item_order, 0, item: items[5])
      create_list(:item_order, 3, item: items[6])
      create_list(:item_order, 2, item: items[7])

      inactive_item_1 = create(:inactive_item)
      inactive_item_2 = create(:inactive_item)
      create_list(:item_order, 10, item: inactive_item_1, quantity: 10000)
      create_list(:item_order, 10, item: inactive_item_2, quantity: 10000)

      visit '/items'

      within '#statistics' do
        expect(page).to have_content("Most Popular Items:")
        expect(page).to have_link(Item.by_quantity_sold[0].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold[0].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold[1].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold[1].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold[2].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold[2].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold[3].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold[3].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold[4].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold[4].quantity_sold)}")

        expect(page).to have_content("Least Popular Items:")
        expect(page).to have_link(Item.by_quantity_sold(direction: 'asc')[0].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold(direction: 'asc')[0].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold(direction: 'asc')[1].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold(direction: 'asc')[1].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold(direction: 'asc')[2].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold(direction: 'asc')[2].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold(direction: 'asc')[3].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold(direction: 'asc')[3].quantity_sold)}")
        expect(page).to have_link(Item.by_quantity_sold(direction: 'asc')[4].name)
        expect(page).to have_content("quantity sold: #{number_to_human(Item.by_quantity_sold(direction: 'asc')[4].quantity_sold)}")
      end
    end
  end
end
