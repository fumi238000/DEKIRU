FactoryBot.define do
  factory :content do
    # association :category, factory: :category
    title { "コンテンツタイトル" }
    subtitle { "サブタイトル" }
    movie_url { "https://www.youtube.com/watch?v=Otrc2zAlJyM" }
    comment { "コメント" }
    point { "ポイント" }
    movie_id { YoutubeUrlFormatter.movie_id_format(movie_url) }
  end
end
