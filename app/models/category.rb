class Category < ApplicationRecord
  has_many :children, class_name: "Category",
    foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :suggestions, dependent: :destroy
  has_many :products, dependent: :destroy
  validates :name, presence: true,
    length: {maximum: Settings.category.name.max_size}
  validates :parent_id, presence: true, allow_nil: true
  scope :largest, ->{where parent_id: 0}
  scope :smaller, ->id{where "parent_id=?", id}

  def generate_children
    Category.smaller(id)
  end
end
