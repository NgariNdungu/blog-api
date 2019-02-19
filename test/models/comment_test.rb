require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  test 'should save comment with valid data' do
    assert_difference('Comment.count') do
      create(:comment, commenter: create(:user, username: "other_user"))
    end
  end

  test 'should not save comment with invalid data' do
    assert_not build(:comment, commenter: nil).save, "Saved a comment without a commenter"
    assert_not build(:comment, post: nil).save, "Saved a comment to a nonexistent post"
    assert_not build(:comment, body: "").save, "Saved an empty comment"
  end

  test 'comment should have a commenter' do
    assert_respond_to build(:comment), :commenter, "Comment doesn't belong to a user"
  end

  test 'comment should belong to a post' do
    assert_respond_to build(:comment), :post, "Comment doesn't belong to a post"
  end
end
