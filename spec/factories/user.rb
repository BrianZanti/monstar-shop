FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip  { Faker::Address.zip }
    email  { Faker::Internet.email }
    password { 'password' }

    factory :merchant_employee do
      role {:merchant_employee}
    end

    factory :admin do
      role {:admin}
    end
  end
end
