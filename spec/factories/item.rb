FactoryBot.define do
  factory :item do
    merchant
    name { 'Itemy item' }
    description { 'It is a very good item' }
    price { 430 }
    image { 'https://image.shutterstock.com/image-vector/online-shopping-ecommerce-concept-business-600w-525331675.jpg' }
    inventory { 364 }
  end
end
