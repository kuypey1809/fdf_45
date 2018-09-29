class Category < ApplicationRecord
  has_many :suggestions, dependent: :destroy
  has_many :products, dependent: :destroy
  validates :name, presence: true,
    length: {maximum: Settings.category.name.max_size}
  validates :parent_id, presence: true
end
