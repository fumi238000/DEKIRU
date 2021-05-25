USER_NUM = 5

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
puts "クリエイターのテストデータを作成しました"

puts "テストデータのインポート終了"
