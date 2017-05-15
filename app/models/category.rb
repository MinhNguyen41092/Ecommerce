class Category < ApplicationRecord
  has_and_belongs_to_many :products
  has_many :accessories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :electronic, class_name: "Category", optional: true

  scope :main_categories, -> {where(parent_id: nil)}

  validates :name, presence: true, uniqueness: true, length: {maximum: Settings.max_name}
end
