class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :user
  validates :user_id, presence: true
end
