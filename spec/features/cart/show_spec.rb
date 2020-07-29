require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @item_1 = create(:item)
        @item_2 = create(:item)
        @item_3 = create(:item)

        visit "/items/#{@item_2.id}"
        click_on "Add To Cart"

        visit "/items/#{@item_1.id}"
        click_on "Add To Cart"

        visit "/items/#{@item_3.id}"
        click_on "Add To Cart"

        @items_in_cart = [@item_2,@item_1,@item_3]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("#{number_to_currency(item.convert_price)}")
            expect(page).to have_content("1")
          end
        end
        cart_total = @items_in_cart.sum {|item| item.convert_price}
        expect(page).to have_content("Total: #{number_to_currency(cart_total)}")

        visit "/items/#{@item_1.id}"
        click_on "Add To Cart"
        cart_total += @item_1.convert_price

        visit '/cart'

        within "#cart-item-#{@item_1.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("#{number_to_currency(@item_1.convert_price * 2)}")
        end

        expect(page).to have_content("Total: #{number_to_currency(cart_total)}")
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
