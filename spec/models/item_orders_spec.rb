require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:user))
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(2.00)
    end

    describe '#convert_price' do
      it 'converts a price to dollars' do
        item_order = create(:item_order, price: 3579)
        expect(item_order.convert_price).to eq(35.79)
      end

      it 'can convert a price with 3 digits' do
        item_order = create(:item_order, price: 101)
        expect(item_order.convert_price).to eq(1.01)
      end

      it 'can convert a price with 2 digits' do
        item_order = create(:item_order, price: 50)
        expect(item_order.convert_price).to eq(0.5)
      end

      it 'can convert a price with 1 digit' do
        item_order = create(:item_order, price: 2)
        expect(item_order.convert_price).to eq(0.02)
      end
    end

    describe '#fulfill' do
      it 'changes filled? to true' do
        item_order = create(:item_order)
        expect(item_order.fulfilled?).to be(false)
        item_order.fulfill
        expect(item_order.fulfilled?).to be(true)
      end

      it 'should call check_fulfillment on the order' do
        item_order = create(:item_order)
        expect(item_order.order).to receive(:check_fulfillment)
        item_order.fulfill
      end
    end
  end

end
