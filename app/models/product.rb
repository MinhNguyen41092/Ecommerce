class Product < ApplicationRecord
  mount_uploader :image_url, ImageUploader
  belongs_to :user
  has_many :line_items
  has_and_belongs_to_many :categories
  has_many :impressions, as: :impressionable
  before_create :approve_product
  before_destroy :not_referenced_by_line_item
  ratyrate_rateable I18n.t("rating")
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true, length: {maximum: Settings.max_name}
  validates :description, length: {maximum: Settings.max_des}
  validates :price, numericality: {greater_than_or_equal_to: Settings.min_price}

  scope :valid_products, -> {where(is_approved: true)}
  scope :most_viewed, -> {order(views: :desc)}
  scope :rating, -> {order(ratings: :desc)}
  scope :order_newest, -> {order(created_at: :desc)}
  scope :order_oldest, -> {order(created_at: :asc)}
  scope :alph, -> {order(title: :asc)}
  scope :price_high_to_low, -> {order(price: :desc)}
  scope :price_low_to_high, -> {order(price: :asc)}

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

   def impression_count
    impressions.size
  end

  def unique_impression_count
    impressions.group(:ip_address).size.keys.length
  end
end
