FactoryBot.define do
  factory :review do
    association :content, factory: :content
    association :user, factory: :user
    comment { "コメント" }
  end
end
