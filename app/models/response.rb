class Response < ApplicationRecord
  belongs_to :question

  validates :response_content, presence: true, length: { in: 1..100, allow_blank: true }

  after_save -> { question.status_update }
end
