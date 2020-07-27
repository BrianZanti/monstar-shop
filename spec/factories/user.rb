FactoryBot.define do
  factory :user do
    name { "Daffy Duck" }
    address { "123 Walt Disney dr."}
    city { "Orlando"}
    state { "Florida"}
    zip  {"32825"}
    email  { "daffy.duck@gamil.com" }
  end
end
