FactoryBot.define do
  factory :tag_master do
    tag_name { Faker::Lorem.characters(number: 10) }
    # tag_type { 0 }
  end
end
