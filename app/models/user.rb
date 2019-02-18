class User < ApplicationRecord
  has_secure_password
  validates :username, :full_name, presence: true
end
