class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :order_id, presence: true
  validates :product_id, presence: true
  scope :details, ->order_id{where "order_id=?", order_id}
end
