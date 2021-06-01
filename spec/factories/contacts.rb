FactoryBot.define do
  factory :contact do
    association :user, factory: :user
    title { Faker::Lorem.characters(number: 32) }
    content { Faker::Lorem.characters(number: 1000) }
    remote_ip { "remote_ip" }
    status { 0 }
  end

  trait :contact_invalid do
    title { "" }
  end
end
