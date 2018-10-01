class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  validates :category_id, presence: true
  validates :name, presence: true,
    length: {maximum: Settings.product.name.max_size}
  validates :description, presence: true,
    length: {maximum: Settings.product.description.max_size}
  validates :price, presence: true
end
