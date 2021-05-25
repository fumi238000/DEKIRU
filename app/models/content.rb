class Content < ApplicationRecord
  validates :title, presence: true, length: { in: 1..16, allow_blank: true }
  validates :subtitle, presence: true, length: { in: 1..32, allow_blank: true }
  # TODO: movie_urlバリデージョン実装時に実装する
  # validates :movie_url, presence: true
  validates :comment, presence: true, length: { in: 1..32, allow_blank: true }
  validates :point, presence: true, length: { in: 1..32, allow_blank: true }
  # validates recommend_status:, presence: true
end
