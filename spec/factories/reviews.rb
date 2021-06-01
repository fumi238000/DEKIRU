FactoryBot.define do
  factory :review do
    association :content, factory: :content
    association :user, factory: :user
    comment { "コメント" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/test_sample.png"), "image/png") }
  end

  trait :review_invalid do
    comment { "" }
  end
end
