class Make < ApplicationRecord
  belongs_to :content

  # CHECK: 32文字で足りるかどうか
  validates :detail, presence: true, length: { in: 1..32, allow_blank: true }
end
