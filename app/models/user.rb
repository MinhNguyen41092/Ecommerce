class User < ApplicationRecord
  has_many :products
  has_many :orders
  has_many :messages
  has_many :chatrooms, through: :messages
  after_initialize :init
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.max_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.max_email},
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.minimum}

  scope :admin, -> {where(is_admin: true)}
  scope :not_admin, -> {where(is_admin: false)}
  scope :order_by_name, -> {order(name: :asc)}

  def init
    self.is_admin = false if self.is_admin.nil?
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
