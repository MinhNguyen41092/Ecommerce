class Product < ApplicationRecord
  belongs_to :user
  has_many :line_items
  has_and_belongs_to_many :categories
  before_create :approve_product
  before_destroy :not_referenced_by_line_item
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true, length: {maximum: Settings.max_name}
  validates :description, length: {maximum: Settings.max_des}
  validates :price, numericality: {greater_than_or_equal_to: Settings.min_price}
  validates :image_url, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: I18n.t("products.image")
  }

  scope :valid_products, -> {where(is_approved: true)}
  scope :order_newest, -> {order(created_at: :desc)}

  def approve_product
    return self.is_approved = true if self.user.is_admin
    self.is_approved = false
  end

  def not_referenced_by_line_item
    unless line_items.empty?
      flash[:danger] = t "products.item_exist"
      throw :abort
    end
  end
end
