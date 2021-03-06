class Contact < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: true, length: { in: 1..32 }
  validates :email, presence: true
  validates :title, presence: true, length: { in: 1..32 }
  validates :content, presence: true, length: { in: 1..1000 }
  validates :remote_ip, presence: true

  enum status: { before: 0, after: 1 }

  include Confirmable
end
