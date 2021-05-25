FactoryBot.define do
  factory :make do
    association :content, factory: :content
    detail { "作り方はこちら" }
  end
end
