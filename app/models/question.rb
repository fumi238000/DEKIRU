class Question < ApplicationRecord
  belongs_to :content
  belongs_to :user
  has_one :response, dependent: :destroy

  validates :question_content, presence: true, length: { in: 1..100, allow_blank: true }

  def response_nil?
    self.response.nil?
  end

  # エラーメッセージ
  def self.question_error_message(q)
    case q.errors.full_messages
    when ["Question contentを入力してください"]
      "質問が入力されていません"
    when ["Question contentは100文字以内で入力してください"]
      "文字数オーバーです。100文字以内で入力してください。"
    else
      "予期せぬエラーが発生しました"
    end
  end
end
