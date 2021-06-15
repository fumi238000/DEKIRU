class Material < ApplicationRecord
  belongs_to :content
  validates :name,   presence: true, length: { in: 1..16, allow_blank: true }
  validates :amount, presence: true, length: { in: 1..5, allow_blank: true }, numericality: { only_integer: true }
  validates :unit,   presence: true, length: { in: 1..5, allow_blank: true }
end
