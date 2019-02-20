class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :full_name

  has_many :posts
end
