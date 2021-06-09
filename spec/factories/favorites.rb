FactoryBot.define do
  factory :favorite do
    association :content, factory: :content
    association :user, factory: :user
  end
end
