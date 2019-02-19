class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :username, :full_name, presence: true
  validates :username, uniqueness: true
end
