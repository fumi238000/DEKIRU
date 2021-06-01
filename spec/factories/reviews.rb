FactoryBot.define do
  factory :review do
    association :content, factory: :content
    association :user, factory: :user
    comment { "コメント" }
    # image { "写真" }
  end

  trait :review_invalid do
    comment { "" }
  end
end
