FactoryBot.define do
  factory :category do
    name { Faker::Lorem.characters(number: 8) }
  end

  trait :category_invalid do
    name { "" }
  end
end
