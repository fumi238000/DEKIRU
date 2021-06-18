class Question < ApplicationRecord
  belongs_to :content
  belongs_to :user
  has_one :response, dependent: :destroy

  validates :question_content, presence: true, length: { in: 1..100, allow_blank: true }

  enum status: { before: 0, after: 1 }

  def response_nil?
    self.response.nil?
  end

  def status_update
    self.status = "after" if self.before?
    self.save!
  end
end
