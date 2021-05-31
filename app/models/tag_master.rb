class TagMaster < ApplicationRecord
  validates :tag_name, presence: true, length: { in: 1..10, allow_blank: true }

  enum tag_type: { content: 0, category: 1 }
end
