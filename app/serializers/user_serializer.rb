class UserSerializer < ActiveModel::Serializer
  type 'user'
  attributes :id, :username, :full_name

  has_many :posts
end
