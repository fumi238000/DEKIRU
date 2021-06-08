# TODO: 長すぎるテストデータのリファクタリング

USER_NUM = 5
CONTENT_NUM = 20
RECOMMEND_CONTENT_NUM = 9
MATERIALS_NUM = 5
MAKES_NUM = 4
REVIEWS_NUM = 3
FAVORITES_NUM = 5
CATEGORIES_NUM = 5
QUESTIONS_NUM = 5
CONTENT_TAGS = ["リフォーム", "メンテナンス", "お風呂", "トイレ", "洗面", "引越し", "新築", "買い替え", "引越し直前", "引き渡し前", "トラブル", "DIY", "キーワード(10字)", "ワード(10文字！)", "ワード(10字？)"].freeze

#-----------------------------------------
puts "テストデータのインポート開始"
#-----------------------------------------

#-----------------------------------------
# admin_user
#-----------------------------------------
User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "管理者ユーザー"
  u.email = "admin@example.com"
  u.password = "password"
  u.user_type = "admin"
end

puts "管理者のテストデータを作成しました".green

#-----------------------------------------
# general_user
#-----------------------------------------
USER_NUM.times do |i|
  id = i + 1
  User.find_or_create_by!(email: "user#{id}@example.com") do |u|
    u.name = "テストユーザー#{id}"
    u.email = "user#{id}@example.com"
    u.password = "password"
  end
end

puts "ユーザーのテストデータを作成しました".green

#-----------------------------------------
# category
#-----------------------------------------
CATEGORIES_NUM.times do |i|
  id = i + 1
  Category.find_or_create_by!(name: "テスト用カテゴリー#{id}(16文字") do |c|
    c.name = "テスト用カテゴリー#{id}(16文字)" # 最大16文字
  end
end
puts "カテゴリーのテストデータを作成しました".green

#-----------------------------------------
# content
#-----------------------------------------
CONTENT_NUM.times do |i|
  id = i + 1
  Content.find_or_create_by!(title: "コンテンツタイトル#{id}(16字)") do |c|
    c.title = "コンテンツタイトル#{id}(16字)" # 最大16文字
    c.subtitle = "サブタイトルサブタイトルサブタイトルサブタイトルサブ(32文字)" # 最大32文字
    c.movie_url = "https://www.youtube.com/watch?v=7z2duD5gHsQ"
    c.comment = "コメントコメントコメントコメントコメントコメントコメ(32文字)" # 最大32文字
    c.point = "ポイントポイントポイントポイントポイントポイントポイ(32文字)" # 最大32文字
    c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
    c.category_id = Category.all.sample.id
  end
end
puts "コンテンツのテストデータを作成しました".green

#-----------------------------------------
# recommend_content
#-----------------------------------------
RECOMMEND_CONTENT_NUM.times do |i|
  id = i + 1
  Content.find_or_create_by!(title: "コンテンツ(おすすめデータ)#{id}") do |c|
    c.title = "コンテンツ(おすすめデータ)#{id}" # 最大16文字
    c.subtitle = "サブタイトルサブタイトルサブタイトルサブタイトルサブ(32文字)" # 最大32文字
    c.movie_url = "https://www.youtube.com/watch?v=7z2duD5gHsQ"
    c.comment = "コメントコメントコメントコメントコメントコメントコメ(32文字)" # 最大32文字
    c.point = "ポイントポイントポイントポイントポイントポイントポイ(32文字)" # 最大32文字
    c.recommend_status = "recommend"
    c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
    c.category_id = Category.all.sample.id
  end
end
puts "おすすめコンテンツのテストデータを作成しました".green

#-----------------------------------------
# material
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").includes(:materials).each do |content|
  MATERIALS_NUM.times do |i|
    next unless rand(2).zero? # tureの場合、作成

    num = i + 1
    content.materials.find_or_create_by!(name: "材料のサンプル#{num}(最大16文字)") do |m|
      m.content_id = content.id
      m.name = "材料のサンプル#{num}(最大16文字)" # 16文字
      m.amount = 10000 # 5文字
      m.unit = "個(5字)" # 5文字
      # 商品へのリンクがあっても面白いかもしれない
    end
  end
end

puts "材料のテストデータを作成しました".green

#-----------------------------------------
# make
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").includes(:makes).each do |content|
  MAKES_NUM.times do |i|
    next unless rand(2).zero? # tureの場合、作成

    num = i + 1
    content.makes.find_or_create_by!(detail: "作り方サンプルデータ#{num}作り方サンプルデータ#{num}(最大32文字まで)") do |m|
      m.content_id = content.id
      m.detail = "作り方サンプルデータ#{num}作り方サンプルデータ#{num}(最大32文字まで)" # 32文字
    end
  end
end

puts "作り方のテストデータを作成しました".green

#-----------------------------------------
# question
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").each do |content|
  QUESTIONS_NUM.times do |i|
    next unless rand(2).zero? # tureの場合、作成

    num = i + 1
    user = User.general.sample
    content.questions.find_or_create_by!(user_id: user.id) do |q|
      q.user_id = user.id
      q.question_content = "質問内容#{num}(最大100文字)質問内容#{num}(最大100文字)質問内容#{num}(最大100文字)質問内容#{num}(最大100文字)質問内容#{num}(最大100文字)質問内容#{num}(最大100文字)質問内容#{num}(最大）" # 100文字
      # m.status = 0
    end
  end
end

puts "質問のテストデータを作成しました".green

#-----------------------------------------
# response
#-----------------------------------------
Question.all.each do |question|
  next unless rand(2).zero? # tureの場合、作成
  next unless question.response.nil?

  Response.create!(
    question_id: question.id,
    response_content: "返信内容(最大100文字)返信内容(最大100文字)返信内容(最大100文字)返信内容(最大100文字)返信内容(最大100文字)返信内容(最大100文字)返信内容(最大100文字)返信内容(最大10", # 100文字
  )
end

puts "質問返信のテストデータを作成しました".green

#-----------------------------------------
# favorite
#-----------------------------------------
User.general.where("name LIKE ?", "テストユーザー%").includes(:favorites).each do |user|
  FAVORITES_NUM.times do
    content = Content.all.sample
    user.favorites.find_or_create_by!(content_id: content.id) do |f|
      f.content_id = content.id
    end
  end
end

puts "お気に入りのテストデータを作成しました".green

#-----------------------------------------
# tag_master
#-----------------------------------------
# タグ（コンテンツ用）
CONTENT_TAGS.each do |tag|
  TagMaster.content.find_or_create_by!(tag_name: tag) do |t|
    t.tag_name = tag
  end
end
puts "タグを作成しました".green

# TODO: 検討中
# タグ（カテゴリー用）
# CATEGORY_TAGS.each do |tag|
#   TagMaster.category.find_or_create_by!(tag_name: tag) do |t|
#     t.tag_name = tag
#   end
# end
# puts "カテゴリー用タグを作成しました"

SAMPLE_CONTENT_TAGS = TagMaster.content

#-----------------------------------------
# content_tag
#-----------------------------------------
# コンテンツタグ
Content.all.each do |content|
  next unless rand(2).zero? # tureの場合、作成する

  tag = SAMPLE_CONTENT_TAGS.sample
  ContentTag.find_or_create_by!(content_id: content.id, tag_id: tag.id) do |t|
    t.content_id = content.id
    t.tag_id = tag.id
  end
end

puts "コンテンツにタグを作成しました".green

#-----------------------------------------
# contact
#-----------------------------------------
user = User.first
Contact.create!(user_id: user.id) do |c|
  c.user_id = user.id
  c.title = "お問い合わせのタイトル(最大16文字)お問い合わせのタイトル最大" # 32文字
  c.content = "お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせタ" # 最大1000文字 # rubocop:disable all
  c.remote_ip = 1111
  # c.status = 0 # 将来的に使用する可能性があるため記述
end

puts "お問い合わせのテストデータを作成しました".green

# TODO: 画像関連でエラーが発生するため、コメントアウトしている
#-----------------------------------------
# review
#-----------------------------------------
# Content.where("title LIKE ?", "コンテンツ%").includes(:reviews).each do |content|
#   if rand(2).zero?  # tureの場合、作成する
#     REVIEWS_NUM.times do
#       user = User.general.sample
#       content.reviews.find_or_create_by!(user_id: user.id) do |r|
#         r.image = open("./db/fixtures/review_sample.png")
#         r.user_id = user.id
#         r.comment = "コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最" # 500文字 # rubocop:disable all
#       end
#     end
#   end
# end

# puts "レビューのテストデータを作成しました".green

#-----------------------------------------
puts "テストデータのインポート終了"
#-----------------------------------------
