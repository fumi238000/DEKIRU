class ContentTag < ApplicationRecord
  belongs_to :tag_master, class_name: "TagMaster", foreign_key: :tag_id, inverse_of: :content_tags
  belongs_to :content, class_name: "Content"

  validates :content_id, uniqueness: { scope: :tag_id }
end
