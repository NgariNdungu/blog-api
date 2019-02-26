class CommentSerializer < ActiveModel::Serializer
  type "comment"
  attributes :id, :body
end
