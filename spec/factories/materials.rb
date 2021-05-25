FactoryBot.define do
  factory :material do
    association :content, factory: :content
    name { "ねじ" }
    amount { 1 }
    unit { "本" }
  end
end
