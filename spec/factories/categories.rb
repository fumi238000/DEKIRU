FactoryBot.define do
  factory :category do
    name { Faker::Book.title }
  end

  trait :category_invalid do
    name { "" }
  end
end
