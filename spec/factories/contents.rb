FactoryBot.define do
  factory :content do
    association :category, factory: :category
    title { Faker::Lorem.characters(number: 16) }
    subtitle { Faker::Lorem.characters(number: 32) }
    movie_url { "https://www.youtube.com/watch?v=Otrc2zAlJyM" }
    comment { Faker::Lorem.characters(number: 32) }
    point { Faker::Lorem.characters(number: 32) }
    movie_id { YoutubeUrlFormatter.movie_id_format(movie_url) }
  end

  trait :content_invalid do
    title { "" }
  end
end
