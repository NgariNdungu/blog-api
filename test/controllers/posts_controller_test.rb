require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = create(:post)
  end

  test 'should create and return a post' do
    assert_difference('Post.count', 1, "Did not create post") do
      post posts_url, params: attributes_for(:post, user_id: @post.user_id)
    end
    assert_match /data/, @response.body, "Does not return created object"
  end

  test 'should fail and return errors for invalid data' do
    assert_no_difference('Post.count') do
      post posts_url, params: attributes_for(:post, title: "", user_id: @post.user_id)
    end
    assert_response :bad_request
    assert_match /errors/, @response.body, "Does not return errors"
  end

  test 'should update and return post' do
    patch post_url(@post), params: attributes_for(:post, title: "updated title")
    @post.reload
    assert_equal "updated title", @post.title, "Does not update post"
    assert_match /data/, @response.body, "Does not return updated post"
  end

  test 'should not update post with invalid data' do
    patch post_url(@post), params: {title: nil}
    assert_response :bad_request
    assert_match /errors/, @response.body, "Does not return errors"
  end

  test 'should delete post' do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
  end

  test 'should return list of posts' do
    get posts_url
    assert_response :ok, "Does not return a successful response"
    assert_match /data/, @response.body, "Does not return list of posts"
  end

  test 'should return a post' do
    get post_url(@post)
    assert_response :ok, "Does not return an existing post"
    assert_match "#{@post.title}", @response.body, "Returns the wrong post"
  end

  test 'should return empty data if post does not exist' do
    get post_url(1)
    assert_response :not_found
    assert_match /null/, @response.body, "Does not return null on 404"
  end
end
