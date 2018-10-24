class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :category
  enum status: [:sended, :accepted, :declined]
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true,
    length: {maximum: Settings.suggestion.name.max_size}
  validates :description, presence: true,
    length: {maximum: Settings.suggestion.description.max_size}
  validates :image, presence: true
  validate :image_size
  mount_uploader :image, ImageUploader
  scope :personal, ->user_id{where "user_id=?", user_id}

  private

  def image_size
    return unless image.size > Settings.product.image.max_size.megabytes
    errors.add(:image, t(".smaller"))
  end
end
