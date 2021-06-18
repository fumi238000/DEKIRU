class Review < ApplicationRecord
  belongs_to :content
  belongs_to :user

  validates :comment, presence: true, length: { in: 1..100, allow_blank: true }
  validates :image, presence: true

  mount_uploader :image, ImageUploader
end
