class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /(09|03|05|07|08)+([0-9]{8})\b/
  has_many :suggestions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  enum role: [:customer, :admin]
  has_secure_password
  validates :name,  presence: true,
    length: {maximum: Settings.user.name.max_size}
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_size},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :address, presence: true,
    length: {maximum: Settings.user.address.max_size}
  validates :phone, presence: true, format: {with: VALID_PHONE_REGEX}
  validates :password, length: {minimum: Settings.user.pass.min_size},
    allow_nil: true
  before_save ->{email.downcase!}
end
