require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)
      @cart = Cart.new({
        @item_1.id.to_s => 1,
        @item_2.id.to_s => 2
      })
    end

    it '#contents' do
      expect(@cart.contents).to eq({
        @item_1.id.to_s => 1,
        @item_2.id.to_s => 2
      })
    end

    it '#add_item()' do
      @cart.add_item(@item_3.id)

      expect(@cart.contents).to eq({
        @item_1.id.to_s => 1,
        @item_2.id.to_s => 2,
        @item_3.id.to_s => 1
      })
    end

    describe '#decrement_item' do
      it 'can decrement the count' do
        expect {
          @cart.decrement_item(@item_2.id)
        }.to change { @cart.count_of(@item_2.id) }.by(-1)
      end

      it 'will remove an item if its count goes to 0' do
        @cart.decrement_item(@item_2.id)
        @cart.decrement_item(@item_2.id)
        expect(@cart.count_of(@item_2.id)).to eq(0)
        item_present = @cart.items.any? do |item, quantity|
          item.id == @item_2.id
        end
        expect(item_present).to be(false)
      end
    end

    it '#count_of' do
      expect(@cart.count_of(@item_1.id)).to eq(1)
      expect(@cart.count_of(@item_2.id)).to eq(2)
      expect(@cart.count_of("XYZ")).to eq(0)
    end

    it '#total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '#items' do
      expect(@cart.items).to eq({@item_1 => 1, @item_2 => 2})
    end

    it '#total' do
      expect(@cart.total).to eq(@item_1.convert_price + @item_2.convert_price * 2)
    end

    it '#subtotal()' do
      expect(@cart.subtotal(@item_1)).to eq(@item_1.convert_price)
      expect(@cart.subtotal(@item_2)).to eq(@item_2.convert_price * 2)
    end
  end
end
