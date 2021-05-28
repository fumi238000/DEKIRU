class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :content

  validates :user_id, uniqueness: {
    scope: :post_id,
    message: "同じコンテンツをお気に入りすることはできません。",
  }
end
