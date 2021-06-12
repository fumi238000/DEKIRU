class TagMaster < ApplicationRecord
  has_many :content_tags, foreign_key: :tag_id, dependent: :destroy, inverse_of: :tag_master
  has_many :contents, through: :content_tags

  validates :tag_name, presence: true, length: { in: 1..8, allow_blank: true }, uniqueness: { case_sensitive: true }

  enum tag_type: { content: 0, category: 1 }
end
