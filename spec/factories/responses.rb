FactoryBot.define do
  factory :response do
    association :question, factory: :question
    response_content { Faker::Lorem.characters(number: 100) }
  end

  trait :response_invalid do
    response_content { "" }
  end
end
