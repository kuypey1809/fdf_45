class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  enum status: [:pending, :delivery, :purchased]
  validates :user_id, presence: true
  scope :personal, ->user_id{where "user_id=?", user_id}
end
