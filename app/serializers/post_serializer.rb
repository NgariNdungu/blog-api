class PostSerializer < ActiveModel::Serializer
  type 'post'
  attributes :id, :title, :text

  belongs_to :author, class_name: "User", foreign_key: "user_id"
end
