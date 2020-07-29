FactoryBot.define do
  factory :item_order do
    item
    order
    quantity { Faker::Number.within(range: 1..10000) }
    price { Faker::Number.within(range: 1..10000) }
  end
end
