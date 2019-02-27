require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  test 'should save comment with valid data' do
    assert_difference('Comment.count') do
      create(:comment, commenter: create(:user, username: "other_user"))
    end
  end

  test 'should not save comment with invalid data' do
    comment = Comment.create
    assert_not comment.save, "Should not save a comment with missing details"
    assert comment.errors[:commenter].present?, "Should have error for missing commenter"
    assert comment.errors[:body].present?, "Should have error for an empty body"
  end

  test 'comment should have a commenter' do
    assert_respond_to build(:comment), :commenter, "Comment should belong to a user"
  end

  test 'comment should belong to a post' do
    assert_respond_to build(:comment), :post, "Comment should belong to a post"
  end
end
