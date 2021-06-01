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

  # TODO: こういった定数はどこかに定義しておく？
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # バリデージョン
  # TODO: ユニーク制約を実装すること
  validates :name, presence: true, length: { in: 1..10, allow_blank: true } # uniqueness: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX } # uniqueness: true
  validates :password, length: { in: 8..16, allow_blank: true },
                       format: { with: /\A[a-zA-Z\d@\-_]+\z/, allow_blank: true,
                                 message: "で利用できるのは、半角英数字および記号(@, -, _)のみです。" }

  enum user_type: { general: 0, admin: 1 }
  mount_uploader :thumbnail, ThumbnailUploader
end
