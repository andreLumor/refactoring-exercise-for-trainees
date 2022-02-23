FactoryBot.define do
  factory :address, class: Hash do
    address_1 {Faker::Address.full_address} 
    address_2 {Faker::Address.secondary_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    country {Faker::Address.country}
    zip {Faker::Address.zip}
    initialize_with { attributes }
  end
end
