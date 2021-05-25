FactoryBot.define do
  factory :user do
    name { "ユーザーネーム" }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(min_length: 8) }
  end
end
