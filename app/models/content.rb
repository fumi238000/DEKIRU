class Content < ApplicationRecord
  has_many :materials, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :users

  validates :title, presence: true, length: { in: 1..16, allow_blank: true }
  validates :subtitle, presence: true, length: { in: 1..32, allow_blank: true }
  # TODO: movie_urlバリデージョン実装時に実装する
  # validates :movie_url, presence: true
  validates :comment, presence: true, length: { in: 1..32, allow_blank: true }
  validates :point, presence: true, length: { in: 1..32, allow_blank: true }
  # validates recommend_status:, presence: true

  enum recommend_status: { general: 0, recommend: 1 }
end
