class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates :stars, presence: true
  validates :product_id, presence: true
  validates :user_id, presence: true
end
