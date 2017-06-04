class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  validates :topic, presence: true, uniqueness: true, case_sensitive: false
  before_validation :sanitize, :namenify

  scope :newest, -> {order(created_at: :desc)}

  def to_param
    self.name
  end

  def namenify
    self.name = self.topic.downcase.gsub(" ", "-")
  end

  def sanitize
    self.topic = self.topic.strip
  end
end
