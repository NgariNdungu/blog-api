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
    assert_not build(:post, author: nil).save, "Saved a post without a valid user"
    assert_not build(:post, title: "").save, "Saved a post without a title"
  end

  test 'post should have comments' do
    assert_respond_to @post, :comments, "Post can't have comments"
  end

  test 'post should belong to a user' do
    assert_respond_to @post, :author, "Post doesn't have an author"
  end
end
