FactoryBot.define do
  factory :content do
    title { "コンテンツタイトル" }
    subtitle { "サブタイトル" }
    movie_url { "URL" }
    comment { "コメント" }
    point { "ポイント" }
    # recommend_status { 1 }
  end
end
