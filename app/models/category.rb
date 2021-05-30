class Category < ApplicationRecord
  has_many :contents, dependent: :nullify

  validates :name, presence: true, length: { in: 1..16, allow_blank: true }
end
