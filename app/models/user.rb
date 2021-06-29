class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_contents, through: :favorites, source: :content
  has_many :questions, dependent: :destroy
  has_many :contacts, dependent: :destroy # TODO: userが消えたとき、お問い合わせ内容を消して良いか検討する

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデージョン
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { in: 1..16, allow_blank: true }, uniqueness: { case_sensitive: true }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: true }
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

  def self.create_sample_date
    gest_user = User.find_by(email: "guest@example.com")
    # お気に入りサンプルデータ
    favorite_num = 10
    return unless gest_user.favorites.count < favorite_num

    favorite_num.times do
      Content.general.first(favorite_num).each do |content|
        gest_user.favorites.find_or_create_by!(content_id: content.id) do |f|
          f.content_id = content.id
        end
      end
    end
  end
end
