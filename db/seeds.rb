# テストデータ用定数
USER_NUM = 5
CONTENT_NUM = 20
RECOMMEND_CONTENT_NUM = 9
MATERIALS_NUM = 5
MAKES_NUM = 4
REVIEWS_NUM = 3
FAVORITES_NUM = 5
QUESTIONS_NUM = 5
CONTENT_TAGS = ["お風呂", "トイレ", "洗面", "リビング", "キッチン", "玄関"].freeze
CATEGORY_TAGS = ["水回り", "新築", "リフォーム", "メンテナンス"].freeze
MAX_CONTENT_TAGS = 3
MAIL_ADMIN = ENV["MAIL_ADMIN"]
MAIL_ADMIN_PASSWPRD = ENV["MAIL_ADMIN_PASSWPRD"]

#-----------------------------------------
puts "テストデータのインポート開始"
#-----------------------------------------

#-----------------------------------------
# admin_user
#-----------------------------------------
User.find_or_create_by!(email: MAIL_ADMIN) do |u|
  u.name = "管理者ユーザー"
  u.email = MAIL_ADMIN
  u.password = MAIL_ADMIN_PASSWPRD
  u.user_type = "admin"
end

puts "管理者データを作成しました".green

#-----------------------------------------
# admin user
#-----------------------------------------
AdminUser.find_or_create_by!(email: MAIL_ADMIN) do |t|
  t.email = MAIL_ADMIN
  t.password = MAIL_ADMIN_PASSWPRD
  t.password_confirmation = MAIL_ADMIN_PASSWPRD
  puts "active_admin用の管理者データを作成しました".green
end

#-----------------------------------------
# tag_master
#-----------------------------------------
# キーワード
CONTENT_TAGS.each do |tag|
  TagMaster.content.find_or_create_by!(tag_name: tag) do |t|
    t.tag_name = tag
  end
end
puts "キーワードを作成しました".green

SAMPLE_CONTENT_TAGS = TagMaster.content.all

#-----------------------------------------
# category
#-----------------------------------------
CATEGORY_TAGS.each do |category|
  Category.find_or_create_by!(name: category) do |c|
    c.name = category # 最大8文字
  end
end
puts "カテゴリーのテストデータを作成しました".green

##======================= 開発環境専用のテストデータここから  =======================##
if Rails.env.development?

  puts "<< 開発環境用のテストデータ作成開始！ >>"

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
  # content
  #-----------------------------------------
  CONTENT_NUM.times do |i|
    id = i + 1
    Content.find_or_create_by!(title: "コンテンツタイトル#{id}(16字)") do |c|
      c.title = "コンテンツタイトル#{id}(16字)" # 最大16文字
      c.subtitle = "サブタイトルサブタイトルサブタイトルサブタイトルサブ(32文字)" # 最大32文字
      c.movie_url = "https://www.youtube.com/watch?v=0JxT2x1B6QM"
      # c.movie_url = "https://www.youtube.com/watch?v=7z2duD5gHsQ"
      c.comment = "コメントコメントコメントコメントコメントコメントコメ(32文字)" # 最大32文字
      c.point = "ポイントポイントポイントポイントポイントポイントポイ(32文字)" # 最大32文字
      c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
      c.category_id = Category.all.sample.id
      c.public_status = "published"
    end
  end
  puts "コンテンツのテストデータを作成しました".green

  #-----------------------------------------
  # non_published_content
  #-----------------------------------------
  CONTENT_NUM.times do |i|
    id = i + 1
    Content.find_or_create_by!(title: "非公開コンテンツ#{id}") do |c|
      c.title = "非公開コンテンツ#{id}" # 最大16文字
      c.subtitle = "サブタイトルサブタイトルサブタイトルサブタイトルサブ(32文字)" # 最大32文字
      c.movie_url = "https://www.youtube.com/watch?v=lE6RYpe9IT0"
      c.comment = "コメントコメントコメントコメントコメントコメントコメ(32文字)" # 最大32文字
      c.point = "ポイントポイントポイントポイントポイントポイントポイ(32文字)" # 最大32文字
      c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
      c.category_id = Category.all.sample.id
      c.public_status = "non_published"
    end
  end
  puts "非公開コンテンツのテストデータを作成しました".green
  #-----------------------------------------
  # recommend_content
  #-----------------------------------------
  RECOMMEND_CONTENT_NUM.times do |i|
    id = i + 1
    Content.find_or_create_by!(title: "コンテンツ(おすすめデータ)#{id}") do |c|
      c.title = "コンテンツ(おすすめデータ)#{id}" # 最大16文字
      c.subtitle = "サブタイトルサブタイトルサブタイトルサブタイトルサブ(32文字)" # 最大32文字
      c.movie_url = "https://www.youtube.com/watch?v=0JxT2x1B6QM"
      # c.movie_url = "https://www.youtube.com/watch?v=7z2duD5gHsQ"
      c.comment = "コメントコメントコメントコメントコメントコメントコメ(32文字)" # 最大32文字
      c.point = "ポイントポイントポイントポイントポイントポイントポイ(32文字)" # 最大32文字
      c.recommend_status = "recommend"
      c.movie_id = YoutubeUrlFormatter.movie_id_format(c.movie_url)
      c.category_id = Category.all.sample.id
      c.public_status = "published"
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
  # content_tag
  #-----------------------------------------
  # コンテンツキーワード
  Content.all.each do |content|
    rand(1..MAX_CONTENT_TAGS).times do
      next unless rand(2).zero? # tureの場合、作成する

      tag = SAMPLE_CONTENT_TAGS.sample
      ContentTag.find_or_create_by!(content_id: content.id, tag_id: tag.id) do |t|
        t.content_id = content.id
        t.tag_id = tag.id
      end
    end
  end

  puts "コンテンツにキーワードを作成しました".green

  #-----------------------------------------
  # contact
  #-----------------------------------------
  user = User.general.first
  Contact.create!(user_id: user.id) do |c|
    c.user_id = user.id
    c.title = "お問い合わせのタイトル(最大16文字)お問い合わせのタイトル最大" # 32文字
    c.content = "お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせ内容(最大100文字)お問い合わせタ" # 最大1000文字 # rubocop:disable all
    c.remote_ip = 1111
    # c.status = 0 # 将来的に使用する可能性があるため記述
  end

  puts "お問い合わせのテストデータを作成しました".green

  # TODO: 画像関連でエラーが発生するため、コメントアウト
  # -----------------------------------------
  # review
  # -----------------------------------------
  Content.where("title LIKE ?", "コンテンツ%").includes(:reviews).each do |content|
    next unless rand(2).zero? # tureの場合、作成する

    REVIEWS_NUM.times do
      user = User.general.sample
      content.reviews.find_or_create_by!(user_id: user.id) do |r|
        r.image = open("./db/fixtures/review_sample.png")
        r.user_id = user.id
        r.comment = "コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最大500文字)コメント(最" # 500文字 # rubocop:disable all
      end
    end
  end

  puts "レビューのテストデータを作成しました".green
  puts "<< 開発環境用のテストデータ作成完了！ >>"

end
#-----------------------------------------
puts "テストデータのインポート終了"
#-----------------------------------------
