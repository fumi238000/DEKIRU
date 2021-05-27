FactoryBot.define do
  factory :make do
    association :content, factory: :content
    detail { Faker::Book.title }
  end

  trait :invalid do
    detail { "" }
  end
end
