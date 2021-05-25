class Material < ApplicationRecord
  belongs_to :content

  validates :name,   length: { in: 1..16, allow_blank: true }
  validates :amount, length: { in: 1..5,  allow_blank: true }, numericality: { only_integer: true }
  # TDOO: enumを使用して選択できる様にするか検討する
  validates :unit,   length: { in: 1..5,  allow_blank: true }
end
