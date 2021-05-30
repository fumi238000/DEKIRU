FactoryBot.define do
  factory :question do
    content { nil }
    user { nil }
    content { "MyString" }
    status { 1 }
  end
end
