class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true,
    length: {maximum: Settings.suggestion.name.max_size}
  validates :description, presence: true,
    length: {maximum: Settings.suggestion.description.max_size}
end
