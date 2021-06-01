FactoryBot.define do
  factory :contact do
    user { nil }
    title { "MyString" }
    content { "MyText" }
    remote_ip { "MyString" }
    status { 1 }
  end
end
