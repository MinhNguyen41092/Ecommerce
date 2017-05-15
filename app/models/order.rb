class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  validates :full_name, :email, :address, :pay_type, :user_id, presence: true

  scope :newest, -> {order(created_at: :desc)}

  enum pay_type: [:cash, :paypal, :credit_card]

  enum status: [:received, :shipped, :canceled]
end
