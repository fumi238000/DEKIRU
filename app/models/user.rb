class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_contents, through: :favorites, source: :content
  has_many :questions, dependent: :destroy
  has_many :contacts, dependent: :destroy # TODO: userが消えたとき、お問い合わせ内容を消して良いか検討する

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # TODO: こういった定数はどこかに定義しておく
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # バリデージョン
  # TODO: ユニーク制約を実装すること
  validates :name, presence: true, length: { in: 1..10, allow_blank: true } # uniqueness: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX } # uniqueness: true
  validates :password, length: { in: 8..16, allow_blank: true },
                       format: { with: /\A[a-zA-Z\d@\-_]+\z/, allow_blank: true,
                                 message: "で利用できるのは、半角英数字および記号(@, -, _)のみです。" }

  enum user_type: { general: 0, admin: 1, discontinued: 2 }
  mount_uploader :thumbnail, ThumbnailUploader

  # ゲストログイン
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64(10)
      user.name = "ゲストユーザー"
    end
  end

  def self.create_guest_sample_date
    gest_user = User.find_by(email: "guest@example.com")
    favorite_num = 10

    # お気に入りサンプルデータ
    favorite_num.times do
      content = Content.all.sample
      gest_user.favorites.find_or_create_by!(content_id: content.id) do |f|
        f.content_id = content.id
      end
    end

    # TODO: 画像導入時にエラーが発生
    # reviews_num = 3
    # レビューサンプルデータ
    # Content.where("title LIKE ?", "コンテンツ%").includes(:reviews).first(3).each do |content|
    #   reviews_num.times do |i|
    #     num = i + 1
    #     content.reviews.find_or_create_by!(comment: "ゲストコメント#{num}") do |r|
    #       r.image = open("./db/fixtures/review_sample.png")
    #       r.user_id = gest_user.id
    #       r.comment = "ゲストコメント#{num}"
    #     end
    #   end
    # end
  end
end
