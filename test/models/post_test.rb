require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @author = create(:user)
    @post = create(:post, author: @author)
  end

  test 'should save post with valid data' do
    assert_difference('Post.count') do
      create(:post, author: @author)
    end
  end

  test 'should not save post with missing data' do
    post = Post.create
    assert_not post.save, "Should not save a post with missing details"
    assert post.errors[:author].present?, "Should have error for a missing author"
    assert post.errors[:title].present?, "Should have error for a blank title"
  end

  test 'post should have comments' do
    assert_respond_to @post, :comments, "Post should have comments"
  end

  test 'post should belong to a user' do
    assert_respond_to @post, :author, "Post should have an author"
  end
end
