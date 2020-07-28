FactoryBot.define do
  factory :order do
    user
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip  { Faker::Address.zip }
  end
end
