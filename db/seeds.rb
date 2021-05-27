# TODO: 定数をまとめること
# 定数
USER_NUM = 5
CONTENT_NUM = 10
RECOMMEND_CONTENT_NUM = 9
MATERIALS_NUM = 5
MAKES_NUM = 4

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
    u.name = "ユーザー#{id}"
    u.email = "user#{id}@example.com"
    u.password = "password"
  end
end

puts "ユーザーのテストデータを作成しました"

#-----------------------------------------
# content
#-----------------------------------------
CONTENT_NUM.times do |i|
  id = i + 1
  Content.find_or_create_by!(title: "コンテンツ#{id}") do |c|
    c.title = "コンテンツ#{id}"
    c.subtitle = "サブタイトル"
    c.movie_url = ""
    c.comment = "コメント"
    c.point = "ポイント"
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
    c.movie_url = ""
    c.comment = "コメント"
    c.point = "ポイント"
    c.recommend_status = "recommend"
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
puts "テストデータのインポート終了"
#-----------------------------------------
