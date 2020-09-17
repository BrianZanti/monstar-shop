require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:item_orders).through(:items)}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:user))
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      user = create(:user)
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include("Denver")
      expect(@meg.distinct_cities).to include("Hershey")
    end

    describe '#pending_orders' do
      before :each do
        @merchant = create(:merchant)
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

      it 'returns any orders that contain the merchants items' do
        expect(@merchant.pending_orders).to include(@order_1)
        expect(@merchant.pending_orders).to include(@order_3)
      end

      it 'only returns orders where the item is unfulfilled' do
        expect(@merchant.pending_orders).to_not include(@order_8)
      end

      it 'returns only pending orders' do
        expect(@merchant.pending_orders).to_not include(@order_5)
        expect(@merchant.pending_orders).to_not include(@order_6)
        expect(@merchant.pending_orders).to_not include(@order_7)
      end

      it 'can return an empty array' do
        merchant = create(:merchant)
        expect(merchant.pending_orders).to eq([])
      end
    end

    describe '#quantity_ordered' do
      it 'returns the count of items' do
        merchant = create(:merchant)
        items = create_list(:item, 3, merchant: merchant)
        order = create(:order)
        create_list(:order, 5)
        item_order_1 = create(:item_order, order: order, item: items.first)
        create_list(:item_order, 5, order: order)
        item_order_2 = create(:item_order, order: order, item: items.second)

        expected = item_order_1.quantity + item_order_2.quantity
        expect(merchant.quantity_ordered(order)).to eq(expected)
      end

      it 'returns 0 if no items on the order' do
        merchant = create(:merchant)
        order = create(:order)
        create_list(:item_order, 3, order: order)
        expect(merchant.quantity_ordered(order)).to eq(0)
      end
    end

    describe '#revenue_from' do
      it 'returns the revenue from items on the order' do
        merchant = create(:merchant)
        items = create_list(:item, 3, merchant: merchant)
        order = create(:order)
        create_list(:order, 5)
        item_order_1 = create(:item_order, order: order, item: items.first)
        create_list(:item_order, 5, order: order)
        item_order_2 = create(:item_order, order: order, item: items.second)

        expected = item_order_1.quantity * item_order_1.convert_price \
                    + item_order_2.quantity * item_order_2.convert_price
        expect(merchant.revenue_from(order).round(2)).to eq(expected.round(2))
      end

      it 'returns 0 if no items on the order' do
        merchant = create(:merchant)
        order = create(:order)
        create_list(:item_order, 3, order: order)
        expect(merchant.revenue_from(order)).to eq(0)
      end
    end
  end

  describe '#pending_orders?' do
    it 'returns true if there are pending orders' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      order = create(:order)
      create(:item_order, item: item, order: order)
      expect(merchant.pending_orders?).to be(true)
    end

    it 'returns false if there are no pending orders' do
      merchant = create(:merchant)
      expect(merchant.pending_orders?).to be(false)
    end
  end

  describe '#toggle' do
    before :each do
      @merchant = create(:merchant)
      @items = create_list(:item, 3, merchant: @merchant)
    end

    it 'can change a merchant from enabled to disabled' do
      expect(@merchant.enabled?).to be(true)
      @merchant.toggle_enabled
      @merchant.reload
      expect(@merchant.enabled?).to be(false)
    end

    it 'can change a merchant from disabled to enabled' do
      @merchant.update(enabled?: false)
      expect(@merchant.enabled?).to be(false)
      @merchant.toggle_enabled
      @merchant.reload
      expect(@merchant.enabled?).to be(true)
    end

    it 'deactivates all of the merchants items when disabling' do
      expect(@merchant.items.any?(&:active?)).to be(true)
      @merchant.toggle_enabled
      expect(@merchant.items.any?(&:active?)).to be(false)
    end

    it 'activates all of the merchants items when enabling' do
      @merchant.items.update(active?: false)
      @merchant.update(enabled?: false)
      expect(@merchant.items.all?(&:active?)).to be(false)
      @merchant.toggle_enabled
      expect(@merchant.items.all?(&:active?)).to be(true)
    end
  end
end
