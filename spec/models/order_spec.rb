require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should define_enum_for(:status)
          .with_values([:pending, :packaged, :shipped, :cancelled])
    }
    it 'should default to pending status' do
      order = Order.create(name: 'a', address: 'a', city: 'a', state: 'a', zip: '11111')
      expect(order.pending?).to be(true)
    end
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it { should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      user = create(:user)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(2.30)
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    describe '#check_fulfillment' do
      it 'changes the order status to packaged if all item orders are fulfilled' do
        order = create(:order)
        create_list(:fulfilled_item_order, 3, order: order)
        item_order = create(:item_order, order: order)
        order.check_fulfillment
        expect(order.packaged?).to be(false)
        item_order.fulfill
        order.check_fulfillment
        expect(order.packaged?).to be(true)
      end

      it 'returns true if it changed the status' do
        order = create(:order)
        create_list(:fulfilled_item_order, 3, order: order)
        item_order = create(:item_order, order: order)
        expect(order.check_fulfillment).to be(false)
        item_order.fulfill
        expect(order.check_fulfillment).to be(true)
      end

      it 'does nothing if there are unfulfilled item_orders' do
        order = create(:order)
        create_list(:fulfilled_item_order, 3, order: order)
        item_order = create(:item_order, order: order)
        expect(order.packaged?).to be(false)
        order.check_fulfillment
        expect(order.packaged?).to be(false)
      end
    end
  end

  describe 'class methods' do
    describe '.by_status' do
      it 'orders all orders by status' do
        create(:shipped_order)
        create_list(:packaged_order, 5)
        create_list(:shipped_order, 2)
        create(:cancelled_order)
        create_list(:order, 5)
        create_list(:packaged_order, 5)
        create_list(:cancelled_order, 5)

        pending = Order.by_status[0...5]
        packaged = Order.by_status[5...15]
        shipped = Order.by_status[15...18]
        cancelled = Order.by_status[18..23]
        pending.each do |pending_order|
          expect(pending_order.status).to eq("pending")
        end
        packaged.each do |packaged_order|
          expect(packaged_order.status).to eq("packaged")
        end
        shipped.each do |shipped_order|
          expect(shipped_order.status).to eq("shipped")
        end
        cancelled.each do |cancelled_order|
          expect(cancelled_order.status).to eq("cancelled")
        end
      end
    end
  end
end
