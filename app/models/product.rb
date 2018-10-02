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
  validates :image, presence: true
  validate :image_size
  mount_uploader :image, ImageUploader
  scope :find_by_cate, ->id {where "category_id=?", id}
  scope :sort_by_datetime, -> { order "created_at DESC" }

  private

  def image_size
    if image.size > Settings.product.image.max_size.megabytes
      errors.add(:image, t(".smaller"))
    end
  end
end
