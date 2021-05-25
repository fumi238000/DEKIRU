# TODO: 定数をまとめること
USER_NUM = 5
CONTENT_NUM = 10

puts "テストデータのインポート開始"

#-----------------------------------------
# user
#-----------------------------------------
# ユーザーのサンプルデータ
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

puts "テストデータのインポート終了"
