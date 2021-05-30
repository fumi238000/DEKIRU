class Category < ApplicationRecord
  has_many :contents, dependent: :nullify
end
