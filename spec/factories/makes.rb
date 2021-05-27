FactoryBot.define do
  factory :make do
    association :content, factory: :content
    detail { Faker::Book.title }
  end

  trait :make_invalid do
    detail { "" }
  end
end
