FactoryBot.define do
  factory :user do
    name { "Daffy Duck" }
    address { "123 Walt Disney dr."}
    city { "Orlando"}
    state { "Florida"}
    zip  {"32825"}
    email  { "daffy.duck@gamil.com" }

    factory :merchant_employee do
      role {:merchant_employee}
    end

    factory :admin do
      role {:admin}
    end
  end
end
