class Question < ApplicationRecord
  belongs_to :content
  belongs_to :user

  validates :question_content, presence: true, length: { in: 1..100, allow_blank: true }
end
