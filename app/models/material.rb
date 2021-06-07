class Material < ApplicationRecord
  belongs_to :content
  # TODO: 文字数足りないかもしれない
  validates :name,   presence: true, length: { in: 1..16, allow_blank: true }
  validates :amount, presence: true, length: { in: 1..5, allow_blank: true }, numericality: { only_integer: true }
  # TDOO: enumを使用して選択できる様にするか検討する
  validates :unit,   presence: true, length: { in: 1..5, allow_blank: true }
end
