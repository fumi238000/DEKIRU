FactoryBot.define do
  factory :tag_master do
    tag_name { Faker::Lorem.characters(number: 8) }
    # tag_type { 0 }
  end

  trait :tag_master_invalid do
    tag_name { "" }
  end
end
