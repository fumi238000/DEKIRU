FactoryBot.define do
  factory :response do
    association :question, factory: :question
    response_content { Faker::Lorem.characters(number: 100) }
  end
end
