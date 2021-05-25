# TODO: 定数をまとめること
# 定数
USER_NUM = 5
CONTENT_NUM = 10
MATERIALS_NUM = 5

#-----------------------------------------
puts "テストデータのインポート開始"
#-----------------------------------------

#-----------------------------------------
# user sample date
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
# content sample date
#-----------------------------------------
# コンテンツのサンプルデータ
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
# material sample date
#-----------------------------------------
# 材料のサンプルデータ
Content.includes(:materials).each do |content|
  MATERIALS_NUM.times do |i|
    num = i + 1
    content.materials.find_or_create_by!(name: "ビス#{num}") do |m|
      m.content_id = content.id
      m.name = "ねじ#{num}"
      m.amount = 100
      m.unit = "個"
    end
  end
end

puts "材料のテストデータを作成しました"

#-----------------------------------------
puts "テストデータのインポート終了"
#-----------------------------------------
