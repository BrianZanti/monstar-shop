require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it 'should default to active' do
      merchant = create(:merchant)
      item = merchant.items.create(name: 'Itemy item', description: 'It is a very good item', price: 430, image: 'https://image.shutterstock.com/image-vector/online-shopping-ecommerce-concept-business-600w-525331675.jpg', inventory: 364)
      expect(item.active?).to eq(true)
    end
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    describe '#convert_price' do
      it 'converts a price to dollars' do
        item = create(:item, price: 3579)
        expect(item.convert_price).to eq(35.79)
      end

      it 'can convert a price with 3 digits' do
        item = create(:item, price: 101)
        expect(item.convert_price).to eq(1.01)
      end

      it 'can convert a price with 2 digits' do
        item = create(:item, price: 50)
        expect(item.convert_price).to eq(0.5)
      end

      it 'can convert a price with 1 digit' do
        item = create(:item, price: 2)
        expect(item.convert_price).to eq(0.02)
      end
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:user))
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe 'class methods' do
    describe '.by_quantity_sold' do
      before :each do
        @item_1 = create(:item)
        @item_2 = create(:item)
        @item_3 = create(:item)
        @item_4 = create(:item)
        @item_5 = create(:item)
        @item_6 = create(:item)
        @item_7 = create(:item)
        @item_8 = create(:item)
      end
    end
  end
end
