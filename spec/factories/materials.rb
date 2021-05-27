FactoryBot.define do
  factory :material do
    association :content, factory: :content
    name { Faker::Lorem.characters(number: 16) }
    amount { Faker::Number.number(digits: 5) }
    unit { Faker::Lorem.characters(number: 5) }
  end

  trait :material_invalid do
    name { "" }
  end
end
