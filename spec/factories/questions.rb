FactoryBot.define do
  factory :question do
    association :content, factory: :content
    association :user, factory: :user
    question_content { Faker::Lorem.characters(number: 100) }
    status { 0 }
  end
end
