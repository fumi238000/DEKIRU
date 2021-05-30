# TODO: 定数をまとめること
# 定数
USER_NUM = 5
CONTENT_NUM = 20
RECOMMEND_CONTENT_NUM = 9
MATERIALS_NUM = 5
MAKES_NUM = 4
REVIEWS_NUM = 3
FAVORITES_NUM = 5
CATEGORIES_NUM = 5
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

puts "管理者のテストデータを作成しました"

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

puts "ユーザーのテストデータを作成しました"

#-----------------------------------------
# category
#-----------------------------------------
CATEGORIES_NUM.times do |i|
  id = i + 1
  Category.find_or_create_by!(name: "カテゴリー#{id}") do |c|
    c.name = "カテゴリー#{id}"
  end
end
puts "カテゴリーのテストデータを作成しました"

#-----------------------------------------
# content
#-----------------------------------------
CONTENT_NUM.times do |i|
  id = i + 1
  Content.find_or_create_by!(title: "コンテンツ#{id}") do |c|
    c.title = "コンテンツ#{id}"
    c.subtitle = "サブタイトル"
    c.movie_url = "https://www.youtube.com/watch?v=Otrc2zAlJyM"
    c.comment = "コメント"
    c.point = "ポイント"
    c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
    c.category_id = Category.all.sample.id
  end
end
puts "コンテンツのテストデータを作成しました"

#-----------------------------------------
# recommend_content
#-----------------------------------------
RECOMMEND_CONTENT_NUM.times do |i|
  id = i + 1
  Content.find_or_create_by!(title: "おすすめコンテンツ#{id}") do |c|
    c.title = "おすすめコンテンツ#{id}"
    c.subtitle = "サブタイトル"
    c.movie_url = "https://www.youtube.com/watch?v=FuYdTDx8ZP4"
    c.comment = "コメント"
    c.point = "ポイント"
    c.recommend_status = "recommend"
    c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
    c.category_id = Category.all.sample.id
  end
end
puts "おすすめコンテンツのテストデータを作成しました"

#-----------------------------------------
# material
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").includes(:materials).each do |content|
  MATERIALS_NUM.times do |i|
    num = i + 1
    content.materials.find_or_create_by!(name: "ねじ#{num}") do |m|
      m.content_id = content.id
      m.name = "ねじ#{num}"
      m.amount = 100
      m.unit = "個"
      # 商品へのリンクがあっても面白いかもしれない
    end
  end
end

puts "材料のテストデータを作成しました"

#-----------------------------------------
# make
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").includes(:makes).each do |content|
  MAKES_NUM.times do |i|
    num = i + 1
    content.makes.find_or_create_by!(detail: "作り方#{num}") do |m|
      m.content_id = content.id
      m.detail = "作り方#{num}"
    end
  end
end

puts "作り方のテストデータを作成しました"

#-----------------------------------------
# review
#-----------------------------------------
Content.where("title LIKE ?", "コンテンツ%").includes(:reviews).each do |content|
  REVIEWS_NUM.times do |i|
    num = i + 1
    content.reviews.find_or_create_by!(comment: "コメント#{num}") do |r|
      r.image = open("./db/fixtures/review_sample.png")
      r.user_id = User.general.sample.id
      r.comment = "コメント#{num}"
    end
  end
end

puts "レビューのテストデータを作成しました"

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

puts "お気に入りのテストデータを作成しました"

#-----------------------------------------
puts "テストデータのインポート終了"
#-----------------------------------------
